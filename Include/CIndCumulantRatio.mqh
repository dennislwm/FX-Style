#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

//---- Assert Basic externs
#include <CStyleBuffer.mqh>

//---- Assert Enums
enum ENUM_CR_AGE_BAR
{
  CR_AGE_BAR_NA,        // NA
  CR_AGE_BAR_BORN,      // == Bar[1], where Bar[0] is current bar
  CR_AGE_BAR_BABY,      // <= Bar[2]
  CR_AGE_BAR_INFANT,    // <= Bar[3]
  CR_AGE_BAR_TODDLER,   // <= Bar[5]
  CR_AGE_BAR_CHILD,     // <= Bar[8]
  CR_AGE_BAR_TEENAGER,  // <= Bar[13]
  CR_AGE_BAR_ADULT,     // <= Bar[21]
  CR_AGE_BAR_PARENT,    // <= Bar[34]
  CR_AGE_BAR_GRAND,     // <= Bar[55]
  CR_AGE_BAR_GREAT      // > Bar[55]
};
enum ENUM_CR_RATIO_LEVEL
{
  CR_RATIO_LEVEL_NA,          // NA
  CR_RATIO_LEVEL_ABOVE,       // Above or equal 0.00
  CR_RATIO_LEVEL_UNDER        // Below 0.00
};

class CIndCumulantRatio: public CStyleBuffer
{
public:
//--- available globally
  ENUM_CR_AGE_BAR       age;
  ENUM_CR_RATIO_LEVEL   ratio;
  CIndCumulantRatio(void):CStyleBuffer(){age=CR_AGE_BAR_NA; ratio=CR_RATIO_LEVEL_NA;}
 
  bool blnReadIndicatorValues (double& b[])
  {
    int CrIndex;
  //--- Assert buffer is valid
    if( b[0]==EMPTY_VALUE ) return false;
    
    if( b[0] >= 0.00 ) 
      ratio=CR_RATIO_LEVEL_ABOVE;
    else 
      ratio=CR_RATIO_LEVEL_UNDER;
      
    for( CrIndex=1; CrIndex<57 ;CrIndex++ )
    {
      if( b[CrIndex] >= 0.0 && ratio==CR_RATIO_LEVEL_UNDER ) break;
      if( b[CrIndex] < 0.0 && ratio==CR_RATIO_LEVEL_ABOVE ) break;
    }
    CrIndex=CrIndex-1;
    if     ( CrIndex <= 1 )    age=CR_AGE_BAR_BORN;
    else if( CrIndex <= 2 )    age=CR_AGE_BAR_BABY;
    else if( CrIndex <= 3 )    age=CR_AGE_BAR_INFANT;
    else if( CrIndex <= 5 )    age=CR_AGE_BAR_TODDLER;
    else if( CrIndex <= 8 )    age=CR_AGE_BAR_CHILD;
    else if( CrIndex <= 13 )   age=CR_AGE_BAR_TEENAGER;
    else if( CrIndex <= 21 )   age=CR_AGE_BAR_ADULT;
    else if( CrIndex <= 34 )   age=CR_AGE_BAR_PARENT;
    else if( CrIndex <= 55 )   age=CR_AGE_BAR_GRAND;
    else if( CrIndex > 55 )    age=CR_AGE_BAR_GREAT;
    
    return true;
  }
  string strGetAgeBar(void)
  {
    ENUM_CR_AGE_BAR a = age;
    if (a == CR_AGE_BAR_BORN)     return("== Bar[1]");
    if (a == CR_AGE_BAR_BABY)     return("<= Bar[2]");
    if (a == CR_AGE_BAR_INFANT)   return("<= Bar[3]");
    if (a == CR_AGE_BAR_TODDLER)  return("<= Bar[5]");
    if (a == CR_AGE_BAR_CHILD)    return("<= Bar[8]");
    if (a == CR_AGE_BAR_TEENAGER) return("<= Bar[13]");
    if (a == CR_AGE_BAR_ADULT)    return("<= Bar[21]");
    if (a == CR_AGE_BAR_PARENT)   return("<= Bar[34]");
    if (a == CR_AGE_BAR_GRAND)    return("<= Bar[55]");
    if (a == CR_AGE_BAR_GREAT)    return("> Bar[55]");
  //--- Got this far, so return NA
     return(na);
  }
  string strGetRatioLevel(void)
  {
    ENUM_CR_RATIO_LEVEL l = ratio;
    if (l == CR_RATIO_LEVEL_ABOVE)  return("Above or equal 0.00");
    if (l == CR_RATIO_LEVEL_UNDER)  return("Under 0.05");
  //--- Got this far, so return NA
     return(na);
  }
  string strPrintTelegram(void)
  {
    string msg=nl;
    msg = StringConcatenate(msg, strPrintStr( "CR Age",strGetAgeBar() ));
    msg = StringConcatenate(msg, strPrintStr( "CR Ratio",strGetRatioLevel() ));
    return( msg );    
  }
};
