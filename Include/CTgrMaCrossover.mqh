#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

//---- Assert Basic externs
#include <CIndMaCrossover.mqh>

class CTgrMaCrossover: public CIndMaCrossover
{
public:
//--- available globally
   CTgrMaCrossover(void):CIndMaCrossover(){return;}
   
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
  string strCrossover(void)
  {
    ENUM_CROSSOVER c = cross;
    if (c == CROSSOVER_ABOVE)  return("FastMa is bullish");
    if (c == CROSSOVER_UNDER)  return("FastMa is bearish");
  //--- Got this far, so return NA
     return(na);
  }
  string strZonePrice(void)
  {
    ENUM_ZONE_PRICE z = zone;
    if (z == ZONE_PRICE_MOMENTUM) return("Price has momentum");
    if (z == ZONE_PRICE_BETWEEN)  return("Price between both MAs");
    if (z == ZONE_PRICE_RETREAT)  return("Price has retreated");
  //--- Got this far, so return NA
    return(na);
  }
  string strPrintTelegram(void)
  {
    string msg=nl+">"+strName()+"<";
    msg = StringConcatenate(msg, strPrintStr( "Age",strAgeBar() ));
    msg = StringConcatenate(msg, strPrintStr( "Crossover",strCrossover() ));
    msg = StringConcatenate(msg, strPrintStr( "Zone",strZonePrice() ));
    return( msg );    
  }
};   