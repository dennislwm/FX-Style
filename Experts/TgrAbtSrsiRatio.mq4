#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property version   "000.900"
#property strict

//---- Assert Basic externs
#include <Telegram.mqh>
#include <CAbtSrsiRatio.mqh>

#define  NL "\n"

//|-----------------------------------------------------------------------------------------|
//|                             C L A S S    C C U S T O M B O T                            |
//|-----------------------------------------------------------------------------------------|
class CBotStyleAlpha: public CCustomBot
{
public:
   void ProcessMessages(void)
   {
      string msg=NL;
      
      for( int i=0; i<m_chats.Total(); i++ ) {
         CCustomChat *chat=m_chats.GetNodeAtIndex(i);
         
         if( !chat.m_new_one.done ) {
            chat.m_new_one.done=true;
            
            string text=chat.m_new_one.message_text;

            if( text=="/cr" ) {
               msg = StringConcatenate( msg,abtest.CrIndicator.strGetRatioLevel(),NL );
               msg = StringConcatenate( msg,abtest.CrIndicator.strGetAgeBar(),NL );
            }
            
            if( text=="/help" || text=="/start" ) {
               msg = StringConcatenate(msg,"My commands list:",NL);
               msg = StringConcatenate(msg,"/cr-return cumulant ratio",NL);
               msg = StringConcatenate(msg,"/help-get help");
            }
            
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
//---- Assert PlusTurtle
#include <PlusTurtle.mqh>
//---- Assert PlusBig
#include <PlusBig.mqh>
extern string IndD1="===Debug Properties===";
extern bool   IndViewDebugNotify         = false;
extern int    IndViewDebug               = 0;
extern int    IndViewDebugNoStack        = 100;
extern int    IndViewDebugNoStackEnd     = 10;
int IndDebugCrit=0;
int IndDebugCore=1;
int IndDebugFine=2;
//|-----------------------------------------------------------------------------------------|
//|                           I N T E R N A L   V A R I A B L E S                           |
//|-----------------------------------------------------------------------------------------|
//---- Assert indicator name and version
string   IndName="TgrAbtSrsiRatio";
string   IndVer="0.9.0";
//---- Assert variables for TGR
CBotStyleAlpha bot;
CAbtSrsiRatio  abtest;
int      intResult;

//|-----------------------------------------------------------------------------------------|
//|                             I N I T I A L I Z A T I O N                                 |
//|-----------------------------------------------------------------------------------------|
int OnInit()
{
   InitInit();
   TurtleInit();
   BigInit();
   
   bot.Token(TgrToken);
   intResult=bot.GetMe();
   
   abtest.Init(Period(), Symbol());
  
//--- create timer
   EventSetTimer(10);
   OnTimer();
   
//---
   return(INIT_SUCCEEDED);
}
int SymbolTfConst2Val(string sym, int tf)
{
   int MNSymbol,MNSymbolCalc;
   for(int a=0;a<6;a++)//turn the Symbol() into an ASCII string and add each character into MNSymbol
   {
      MNSymbolCalc=StringGetChar(sym, a);
      MNSymbolCalc=((MNSymbolCalc-64)*(MathPow(10,(a))));//subtract 64 b/c ASCII characters start at 65, multiply result by the a-th power for neatness (unnecessary though)
      MNSymbol = MNSymbol+MNSymbolCalc;
   }
   return( MNSymbol+tf );
}

//|-----------------------------------------------------------------------------------------|
//|                             D E I N I T I A L I Z A T I O N                             |
//|-----------------------------------------------------------------------------------------|
void OnDeinit(const int reason)
{
//--- destroy timer
   EventKillTimer();
   
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
   
   abtest.ReadIndicatorValues();
   
   bot.ProcessMessages();
}
//|-----------------------------------------------------------------------------------------|
//|                           I N T E R N A L   F U N C T I O N S                           |
//|-----------------------------------------------------------------------------------------|
void IndDebugPrint(int dbg, string fn, string msg)
{
   static int noStackCount;
   if(IndViewDebug>=dbg)
   {
      if(dbg>=IndDebugFine && IndViewDebugNoStack>0)
      {
         if( MathMod(noStackCount,IndViewDebugNoStack) <= IndViewDebugNoStackEnd )
            Print(IndViewDebug,"-",noStackCount,":",fn,"(): ",msg);
            
         noStackCount ++;
      }
      else
      {
         if(IndViewDebugNotify) SendNotification( IndViewDebug + ":" + fn + "(): " + msg );
         Print(IndViewDebug,":",fn,"(): ",msg);
      }
   }
}
string IndDebugInt(string key, int val)
{
   return( StringConcatenate(";",key,"=",val) );
}
string IndDebugDbl(string key, double val, int dgt=5)
{
   return( StringConcatenate(";",key,"=",NormalizeDouble(val,dgt)) );
}
string IndDebugStr(string key, string val)
{
   return( StringConcatenate(";",key,"=\"",val,"\"") );
}
string IndDebugBln(string key, bool val)
{
   string valType;
   if( val )   valType="true";
   else        valType="false";
   return( StringConcatenate(";",key,"=",valType) );
}
//|-----------------------------------------------------------------------------------------|
//|                            E N D   O F   I N D I C A T O R                              |
//|-----------------------------------------------------------------------------------------|