#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

#include <CStyleAbtest.mqh>
#include <CIndCumulantRatio.mqh>
#include <CIndMaCrossover.mqh>

class CAbtSrsiRatio: public CStyleAbtest
{
protected:
//---- Assert inputs for CumulantRatio
   int inpCrPeriod;
   int inpCrAlpha;
   int inpRatioIndex;
//---- Assert inputs for AdaptiveEMA
   int inpMaType, inpMaFastPeriod, inpMaSlowPeriod, inpMaF, inpMaS;
   int inpMaBufferIndex;
//---- Assert buffers
   double bufRatio[];
   double bufFastMa[],bufSlowMa[],bufClose[];
public:
   CIndCumulantRatio IndicatorRatio;
   CIndMaCrossover IndicatorCrossover;

//---- Constructor
   CAbtSrsiRatio(void):CStyleAbtest(){return;}
   void Init(int p, string s) override
   {
      inpCrPeriod=   7;
      inpCrAlpha=    100;
      inpRatioIndex= 0;
      IndicatorRatio.Init(p,s);

      inpMaType=        3;
      inpMaFastPeriod=  10;
      inpMaSlowPeriod=  50;
      inpMaF=           10;
      inpMaS=           50;
      inpMaBufferIndex= 0;
      IndicatorCrossover.Init(p,s);
   }
   void DeInit(void) override
   {
      ArrayFree(bufRatio);
      ArrayFree(bufFastMa);
      ArrayFree(bufSlowMa);
      ArrayFree(bufClose);
      delete &IndicatorRatio;
      delete &IndicatorCrossover;
   }

   void IndicatorValues(void) override
   {
   //--- Declare, resize, fill and read buffers
   //--- CIndCumulantRatio
      if( IndicatorRatio.isNewBar() )
      {
        ArrayResize(bufRatio,IndicatorRatio.intSizeRatio());
        for(int i=0; i<IndicatorRatio.intSizeRatio(); i++)
        {
          bufRatio[i]=      iCustom( IndicatorRatio.strSymbol(),IndicatorRatio.intPeriod(),"CumulantRatio",inpCrPeriod,inpCrAlpha,inpRatioIndex,i );
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
          bufFastMa[i]=  iCustom( IndicatorCrossover.strSymbol(),IndicatorCrossover.intPeriod(),"AdaptiveEMA","","",inpMaType,inpMaFastPeriod,inpMaF,inpMaS,inpMaBufferIndex,i );
          bufSlowMa[i]=  iCustom( IndicatorCrossover.strSymbol(),IndicatorCrossover.intPeriod(),"AdaptiveEMA","","",inpMaType,inpMaSlowPeriod,inpMaF,inpMaS,inpMaBufferIndex,i );
        }
        for(int i=0; i<IndicatorCrossover.intSizePrice(); i++) 
        {
          bufClose[i]=   iClose( IndicatorCrossover.strSymbol(),IndicatorCrossover.intPeriod(),i );
        }
        IndicatorCrossover.blnIndicatorValues(bufFastMa,bufSlowMa,bufClose);
      }
   }   
};

