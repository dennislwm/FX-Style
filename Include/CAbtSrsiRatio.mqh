#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

#include <CStyleAbtest.mqh>
#include <CIndCumulantRatio.mqh>


class CAbtSrsiRatio: public CStyleAbtest
{
public:
//---- Assert inputs for indicators
   int CrPeriod;
   int CrAlpha;
   int CrBufferIndex;

   CIndCumulantRatio CrIndicator;

//---- Constructor
   CAbtSrsiRatio(void):CStyleAbtest(){return;}
   void Init(int p, string s) override
   {
      CrPeriod=      7;
      CrAlpha=       100;
      CrBufferIndex= 0;
      CrIndicator.Init(p,s);
   }

   void ReadIndicatorValues(int bar=60)
   {
   //--- Declare buffers
      double CrBuffer[];

   //--- Resize buffers
      ArrayResize(CrBuffer,bar);

   //--- Fill buffers
      for(int i=0; i<bar; i++)
      {
         CrBuffer[i]=iCustom(CrIndicator.symbol,CrIndicator.period,"CumulantRatio",CrPeriod,CrAlpha,CrBufferIndex,i);
      }

   //--- Read indicator values
      CrIndicator.blnReadIndicatorValues(CrBuffer);
   }   
};

