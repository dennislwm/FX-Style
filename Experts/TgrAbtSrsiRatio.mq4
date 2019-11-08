#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property version   "1.200"
#property strict

//---- Assert Basic externs
#include <Telegram.mqh>
#include <CAbtSrsiRatio.mqh>

//|-----------------------------------------------------------------------------------------|
//|                             C L A S S    C C U S T O M B O T                            |
//|-----------------------------------------------------------------------------------------|
class CBotStyleAlpha: public CCustomBot
{
public:
   void ProcessMessages(void)
   {
      string msg=nl;
      
      for( int i=0; i<m_chats.Total(); i++ ) {
         CCustomChat *chat=m_chats.GetNodeAtIndex(i);
         
         if( !chat.m_new_one.done ) {
            chat.m_new_one.done=true;
            
            string text=chat.m_new_one.message_text;

            if( text=="/srsid1" ) {
               for(int a=0; a<ArraySize(abtestD1); a++) 
               {
                  if( abtestD1[a].IndicatorCrossover.eZonePrice() >= ZONE_PRICE_BETWEEN )
                  {
                     if(( abtestD1[a].IndicatorSrsi.eZoneLine()<=ZONE_LINE_POSITIVE_RETREAT && abtestD1[a].IndicatorCrossover.eCrossover()==CROSSOVER_ABOVE && abtestD1[a].IndicatorRatio.eHistogramLevel()==HISTOGRAM_LEVEL_ABOVE )
                     || ( abtestD1[a].IndicatorSrsi.eZoneLine()>=ZONE_LINE_NEGATIVE_MOMENTUM && abtestD1[a].IndicatorCrossover.eCrossover()==CROSSOVER_UNDER && abtestD1[a].IndicatorRatio.eHistogramLevel()==HISTOGRAM_LEVEL_UNDER ))
                     {
                        msg = StringConcatenate( msg, nl, strSymbol[a], " D1" );
                        msg = StringConcatenate( msg, abtestD1[a].IndicatorSrsi.strPrintTelegram() );
                        msg = StringConcatenate( msg, abtestD1[a].IndicatorCrossover.strPrintTelegram() );
                        msg = StringConcatenate( msg, abtestD1[a].IndicatorRatio.strPrintTelegram() );
                     }
                  }
               }
            }
            if( text=="/srsih4" ) {
               for(int a=0; a<ArraySize(abtestH4); a++) 
               {
                  if( abtestH4[a].IndicatorCrossover.eZonePrice() >= ZONE_PRICE_BETWEEN )
                  {
                     if(( abtestH4[a].IndicatorSrsi.eZoneLine()<=ZONE_LINE_POSITIVE_RETREAT && abtestH4[a].IndicatorCrossover.eCrossover()==CROSSOVER_ABOVE && abtestH4[a].IndicatorRatio.eHistogramLevel()==HISTOGRAM_LEVEL_ABOVE )
                     || ( abtestH4[a].IndicatorSrsi.eZoneLine()>=ZONE_LINE_NEGATIVE_MOMENTUM && abtestH4[a].IndicatorCrossover.eCrossover()==CROSSOVER_UNDER && abtestH4[a].IndicatorRatio.eHistogramLevel()==HISTOGRAM_LEVEL_UNDER ))
                     {                  
                        msg = StringConcatenate( msg, nl, strSymbol[a], " H4");
                        msg = StringConcatenate( msg, abtestH4[a].IndicatorSrsi.strPrintTelegram() );
                        msg = StringConcatenate( msg, abtestH4[a].IndicatorCrossover.strPrintTelegram() );
                        msg = StringConcatenate( msg, abtestH4[a].IndicatorRatio.strPrintTelegram() );
                     }
                  }
               }
            }
           
            if( text=="/help" || text=="/start" ) {
               msg = StringConcatenate(msg,"My commands list:",nl);
               msg = StringConcatenate(msg,"/srsid1-return D1 srsi ratio",nl);
               msg = StringConcatenate(msg,"/srsih4-return H4 srsi ratio",nl);
               msg = StringConcatenate(msg,"/help-get help");
            }
            if( msg==nl ) msg=StringConcatenate(msg,"no match");
            SendMessage( chat.m_id, msg );
         }
      }
   }
};

//|-----------------------------------------------------------------------------------------|
//|                           E X T E R N A L   V A R I A B L E S                           |
//|-----------------------------------------------------------------------------------------|
input   string s1="-->TGR Settings<--";
extern   string s1_1="Token - Telegram API Token";
input    string  TgrToken;
#include <PlusInit.mqh>
//---- Assert PlusBig
#include <PlusBig.mqh>

//|-----------------------------------------------------------------------------------------|
//|                           I N T E R N A L   V A R I A B L E S                           |
//|-----------------------------------------------------------------------------------------|
//---- Assert indicator name and version
string   IndName="TgrAbtSrsiRatio";
string   IndVer="1.200";
//---- Assert variables for TGR
CBotStyleAlpha bot;
CAbtSrsiRatio  *abtestD1[21];
CAbtSrsiRatio  *abtestH4[21];
const string   strSymbol[21] = {"EURGBP","EURAUD","EURNZD","EURUSD","EURCAD","EURJPY","GBPAUD","GBPNZD","GBPUSD","GBPCAD","GBPJPY","AUDNZD","AUDUSD","AUDCAD","AUDJPY","NZDUSD","NZDCAD","NZDJPY","USDCAD","USDJPY","CADJPY"};
      int      intSrsiD1[21] = {      34,      55,      55,      55,      48,      55,      55,      37,      35,      55,      55,      55,      55,      34,      55,      55,      55,      55,      55,      55,      55};
      int      intSrsiH4[21] = {      21,      55,      55,      20,      55,      55,      29,      55,      55,      55,      55,      55,      55,      44,      55,      55,      55,      55,      65,      55,      55};
      int      intResult;

//|-----------------------------------------------------------------------------------------|
//|                             I N I T I A L I Z A T I O N                                 |
//|-----------------------------------------------------------------------------------------|
int OnInit()
{
   InitInit();
   BigInit();
   
   bot.Token(TgrToken);
   intResult=bot.GetMe();

   for(int i=0; i<ArraySize(abtestD1); i++) 
   {
      CAbtSrsiRatio *abtest = new CAbtSrsiRatio();
      abtest.Init( PERIOD_D1, strSymbol[i] );
      abtest.LookBackBar( intSrsiD1[i] );
      abtestD1[i] = abtest;
   }

   for(int i=0; i<ArraySize(abtestH4); i++) 
   {
      CAbtSrsiRatio *abtest = new CAbtSrsiRatio();
      abtest.Init(PERIOD_H4, strSymbol[i]);
      abtest.LookBackBar( intSrsiH4[i] );
      abtestH4[i] = abtest;
   }
  
//--- create timer
   EventSetTimer(10);
   OnTimer();
   
//---
   return(INIT_SUCCEEDED);
}

//|-----------------------------------------------------------------------------------------|
//|                             D E I N I T I A L I Z A T I O N                             |
//|-----------------------------------------------------------------------------------------|
void OnDeinit(const int reason)
{
//--- destroy timer
   EventKillTimer();

   for(int i=0; i<ArraySize(abtestD1); i++){abtestD1[i].DeInit(); delete abtestD1[i];}
   for(int i=0; i<ArraySize(abtestH4); i++){abtestH4[i].DeInit(); delete abtestH4[i];}
   delete &bot;
  
   BigDeInit();
}
//|-----------------------------------------------------------------------------------------|
//|                               T I M E R   F U N C T I O N                               |
//|-----------------------------------------------------------------------------------------|
void OnTimer()
{
//--- Assert intResult=0 (success)
   if( intResult!=0 ) {
      BigComment( "Error: "+GetErrorDescription(intResult) );
      return;
   }
   if( !IsTesting() ) 
      BigComment( "Bot name: "+bot.Name() );
   
   bot.GetUpdates();

//--- Read indicator values
   for(int i=0; i<ArraySize(abtestD1); i++){abtestD1[i].IndicatorValues();}
   for(int i=0; i<ArraySize(abtestH4); i++){abtestH4[i].IndicatorValues();}
   
   bot.ProcessMessages();
}
//|-----------------------------------------------------------------------------------------|
//|                            E N D   O F   I N D I C A T O R                              |
//|-----------------------------------------------------------------------------------------|