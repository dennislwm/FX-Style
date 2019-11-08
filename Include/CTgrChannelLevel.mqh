#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

//---- Assert Basic externs
#include <CIndChannelLevel.mqh>

class CTgrChannelLevel: public CIndChannelLevel
{
public:
//--- available globally
   CTgrChannelLevel(void):CIndChannelLevel(){return;}

//--- string
   string strZoneLine(void)
   {
      ENUM_ZONE_LINE z = zone;
      if( z==ZONE_LINE_POSITIVE_MOMENTUM )   return("Green line has momentum");
      if( z==ZONE_LINE_POSITIVE_RETREAT )    return("Green line has retreated");
      if( z==ZONE_LINE_NEGATIVE_MOMENTUM )   return("Red line has momentum");
      if( z==ZONE_LINE_NEGATIVE_RETREAT )    return("Red line has retreated");
  //--- Got this far, so return NA
      return(na);
   }
   string strSlopeLine(void)
   {
      ENUM_SLOPE_LINE s = slope;
      if( s==SLOPE_LINE_UP )     return("Line is sloping up");
      if( s==SLOPE_LINE_DOWN )   return("Line is sloping down");
  //--- Got this far, so return NA
      return(na);
   }
   string strPrintTelegram(void)
   {
      string msg=nl+">"+strName()+"<";
      msg = StringConcatenate(msg, strPrintStr( "Zone",strZoneLine() ));
      msg = StringConcatenate(msg, strPrintStr( "Slope",strSlopeLine() ));
      return( msg );    
   }
};