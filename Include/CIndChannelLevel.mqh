#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

//---- Assert Basic externs
#include <CStyleBuffer.mqh>

class CIndChannelLevel: public CStyleBuffer
{
protected:
//--- available through methods
   ENUM_ZONE_LINE    zone;
   ENUM_SLOPE_LINE   slope;
   int               size_line;
public:
//--- available globally
   CIndChannelLevel(void):CStyleBuffer(){zone=ZONE_LINE_NA;slope=SLOPE_LINE_NA; size_line=2; name="ChannelLevel";}

   bool blnIndicatorValues (double& b1[], double& b2[], double level) override
   {
   //--- local variables
      double green, red, uppChannel, lowChannel;

   //--- Assert buffer is valid
      if( b1[0]==EMPTY_VALUE && b2[0]==EMPTY_VALUE ) return false;

      green=      b1[0];
      red=        b2[0];
      uppChannel= level;
      lowChannel= -level;
      
   //--- Assign values to enum types
      if( green==EMPTY_VALUE )
      {
      //--- zone
         if( red>=lowChannel )   zone=ZONE_LINE_NEGATIVE_RETREAT;
         if( red<lowChannel )    zone=ZONE_LINE_NEGATIVE_MOMENTUM;
      //--- slope
         if( red>=b2[1] )        slope=SLOPE_LINE_UP;
         if( red<b2[1] )         slope=SLOPE_LINE_DOWN;
      }
      else   
      {
      //--- zone
         if( green>=uppChannel ) zone=ZONE_LINE_POSITIVE_MOMENTUM;
         if( green<uppChannel)   zone=ZONE_LINE_POSITIVE_RETREAT;
      //--- slope
         if( green>=b1[1] )      slope=SLOPE_LINE_UP;
         if( green<b1[1] )       slope=SLOPE_LINE_DOWN;
      }
      return true;
   }
   ENUM_ZONE_LINE     eZoneLine(void){return zone;}
   ENUM_SLOPE_LINE    eSlopeLine(void){return slope;}
   int    intSizeLine(void){return size_line;}
};