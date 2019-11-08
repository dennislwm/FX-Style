#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

//---- Assert Basic externs
#include <CIndHistogram.mqh>

class CTgrHistogram: public CIndHistogram
{
public:
//--- available globally
   CTgrHistogram(void):CIndHistogram(){return;}

//--- string
  string strAgeBar(void)
  {
    ENUM_AGE_BAR a = age;
    if (a == AGE_BAR_BORN)     return("== Bar[1]");
    if (a == AGE_BAR_BABY)     return("<= Bar[2]");
    if (a == AGE_BAR_INFANT)   return("<= Bar[3]");
    if (a == AGE_BAR_TODDLER)  return("<= Bar[5]");
    if (a == AGE_BAR_CHILD)    return("<= Bar[8]");
    if (a == AGE_BAR_TEENAGER) return("<= Bar[13]");
    if (a == AGE_BAR_ADULT)    return("<= Bar[21]");
    if (a == AGE_BAR_PARENT)   return("<= Bar[34]");
    if (a == AGE_BAR_GRAND)    return("<= Bar[55]");
    if (a == AGE_BAR_GREAT)    return("> Bar[55]");
  //--- Got this far, so return NA
     return(na);
  }
  string strRatioLevel(void)
  {
    ENUM_HISTOGRAM_LEVEL l = hist;
    if (l == HISTOGRAM_LEVEL_ABOVE)  return("Above or equal 0.00");
    if (l == HISTOGRAM_LEVEL_UNDER)  return("Under 0.00");
  //--- Got this far, so return NA
     return(na);
  }
  string strPrintTelegram(void)
  {
    string msg=nl+">"+strName()+"<";
    msg = StringConcatenate(msg, strPrintStr( "Age",strAgeBar() ));
    msg = StringConcatenate(msg, strPrintStr( "Ratio",strRatioLevel() ));
    return( msg );    
  }
};