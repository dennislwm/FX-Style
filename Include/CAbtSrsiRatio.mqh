#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

#include <CStyleAbtest.mqh>
#include <CTgrHistogram.mqh>
#include <CTgrMaCrossover.mqh>
#include <CTgrChannelLevel.mqh>

class CAbtSrsiRatio: public CStyleAbtest
{
protected:
   int inpShift;
//---- Assert inputs and buffers
//       CumulantRatio
   int inpCrPeriod;
   int inpCrAlpha;
   int inpRatioIndex;
   double bufRatio[];
//       AdaptiveEMA
   int inpMaType, inpMaFastPeriod, inpMaSlowPeriod, inpMaF, inpMaS;
   int inpMaBufferIndex;
   double bufFastMa[],bufSlowMa[],bufClose[];
//       SRSI
   int inpLookBackBar;
   int inpTf;
   double inpLevelNeutral;
   double inpLevelSellBuy;
   int inpGreenIndex, inpRedIndex;
   double bufGreen[],bufRed[];
public:
   CTgrHistogram     IndicatorRatio;
   CTgrMaCrossover   IndicatorCrossover;
   CTgrChannelLevel  IndicatorSrsi;

//---- Constructor
   CAbtSrsiRatio(void):CStyleAbtest(){return;}
   void Init(int p, string s) override
   {
      inpShift=1;
      
      inpCrPeriod=   7;
      inpCrAlpha=    100;
      inpRatioIndex= 0;
      IndicatorRatio.Init(p,s);
      IndicatorRatio.Name("CumulantRatio");

      inpMaType=        3;
      inpMaFastPeriod=  10;
      inpMaSlowPeriod=  50;
      inpMaF=           10;
      inpMaS=           50;
      inpMaBufferIndex= 0;
      IndicatorCrossover.Init(p,s);
      IndicatorCrossover.Name("AdaptiveEMA");

      inpLookBackBar=   55;
      inpTf=            0;
      inpLevelNeutral=  0.05;
      inpLevelSellBuy=  0.38;
      inpGreenIndex=    0;
      inpRedIndex=      1;
      IndicatorSrsi.Init(p,s);
      IndicatorSrsi.Name("SRSI");
   }
   void DeInit(void) override
   {
      ArrayFree(bufRatio);
      ArrayFree(bufFastMa);
      ArrayFree(bufSlowMa);
      ArrayFree(bufClose);
      ArrayFree(bufGreen);
      ArrayFree(bufRed);
      delete &IndicatorRatio;
      delete &IndicatorCrossover;
      delete &IndicatorSrsi;
   }
   void LookBackBar(int p){inpLookBackBar=p;}

   void IndicatorValues(void) override
   {
   //--- Declare, resize, fill and read buffers
   //--- CIndCumulantRatio
      if( IndicatorRatio.isNewBar() )
      {
        ArrayResize(bufRatio,IndicatorRatio.intSizeRatio());
        for(int i=0; i<IndicatorRatio.intSizeRatio(); i++)
        {
          bufRatio[i]=      iCustom( IndicatorRatio.strSymbol(),IndicatorRatio.intPeriod(),"CumulantRatio",inpCrPeriod,inpCrAlpha,inpRatioIndex,i+inpShift );
        }
        IndicatorRatio.blnIndicatorValues(bufRatio);
      }
      
   //--- CIndMaCrossover
      if( IndicatorCrossover.isNewBar() )
      {
        ArrayResize(bufFastMa,IndicatorCrossover.intSizeMa());
        ArrayResize(bufSlowMa,IndicatorCrossover.intSizeMa());
        ArrayResize(bufClose,IndicatorCrossover.intSizePrice());
        for(int i=0; i<IndicatorCrossover.intSizeMa(); i++)
        {
          bufFastMa[i]=  iCustom( IndicatorCrossover.strSymbol(),IndicatorCrossover.intPeriod(),"AdaptiveEMA","","",inpMaType,inpMaFastPeriod,inpMaF,inpMaS,inpMaBufferIndex,i+inpShift );
          bufSlowMa[i]=  iCustom( IndicatorCrossover.strSymbol(),IndicatorCrossover.intPeriod(),"AdaptiveEMA","","",inpMaType,inpMaSlowPeriod,inpMaF,inpMaS,inpMaBufferIndex,i+inpShift );
        }
        for(int i=0; i<IndicatorCrossover.intSizePrice(); i++) 
        {
          bufClose[i]=   iClose( IndicatorCrossover.strSymbol(),IndicatorCrossover.intPeriod(),i+inpShift );
        }
        IndicatorCrossover.blnIndicatorValues(bufFastMa,bufSlowMa,bufClose);
      }
      
   //--- CIndChannelLevel
      if( IndicatorSrsi.isNewBar() )
      {
         ArrayResize(bufGreen,IndicatorSrsi.intSizeLine());
         ArrayResize(bufRed,IndicatorSrsi.intSizeLine());
         for(int i=0; i<IndicatorSrsi.intSizeLine(); i++)
         {
            bufGreen[i]=iCustom( IndicatorSrsi.strSymbol(),IndicatorSrsi.intPeriod(),"SRSI","","","","","","",inpLookBackBar,inpTf,inpLevelNeutral,inpLevelSellBuy,inpGreenIndex,i+inpShift );
            bufRed[i]=  iCustom( IndicatorSrsi.strSymbol(),IndicatorSrsi.intPeriod(),"SRSI","","","","","","",inpLookBackBar,inpTf,inpLevelNeutral,inpLevelSellBuy,inpRedIndex,i+inpShift );
         }
         IndicatorSrsi.blnIndicatorValues(bufGreen,bufRed,inpLevelNeutral);
      }
   }   
};

