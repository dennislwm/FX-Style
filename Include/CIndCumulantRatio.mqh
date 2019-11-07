#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

//---- Assert Basic externs
#include <CStyleBuffer.mqh>

class CIndCumulantRatio: public CStyleBuffer
{
protected:
//--- available through methods
  ENUM_AGE_BAR       age;
  ENUM_RATIO_LEVEL   ratio;
  int                size_ratio;
  string             ind_name;  

public:
//--- available globally
  CIndCumulantRatio(void):CStyleBuffer(){age=AGE_BAR_NA; ratio=RATIO_LEVEL_NA; size_ratio=56; ind_name="CumulantRatio";}
 
  bool blnIndicatorValues (double& b[])
  {
    int CrIndex;
  //--- Assert buffer is valid
    if( b[0]==EMPTY_VALUE ) return false;
    
    if( b[0] >= 0.00 ) 
      ratio=RATIO_LEVEL_ABOVE;
    else 
      ratio=RATIO_LEVEL_UNDER;
      
    for( CrIndex=1; CrIndex<size_ratio-1 ;CrIndex++ )
    {
      if( b[CrIndex] >= 0.0 && ratio==RATIO_LEVEL_UNDER ) break;
      if( b[CrIndex] < 0.0 && ratio==RATIO_LEVEL_ABOVE ) break;
    }
    CrIndex=CrIndex-1;
    if     ( CrIndex <= 1 )    age=AGE_BAR_BORN;
    else if( CrIndex <= 2 )    age=AGE_BAR_BABY;
    else if( CrIndex <= 3 )    age=AGE_BAR_INFANT;
    else if( CrIndex <= 5 )    age=AGE_BAR_TODDLER;
    else if( CrIndex <= 8 )    age=AGE_BAR_CHILD;
    else if( CrIndex <= 13 )   age=AGE_BAR_TEENAGER;
    else if( CrIndex <= 21 )   age=AGE_BAR_ADULT;
    else if( CrIndex <= 34 )   age=AGE_BAR_PARENT;
    else if( CrIndex <= 55 )   age=AGE_BAR_GRAND;
    else if( CrIndex > 55 )    age=AGE_BAR_GREAT;
    
    return true;
  }
  ENUM_AGE_BAR       eAgeBar(void){return age;}
  ENUM_RATIO_LEVEL   eRatioLevel(void){return ratio;}
  int    intSizeRatio(void){return size_ratio;}
  string strName(void){return ind_name;}
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
    ENUM_RATIO_LEVEL l = ratio;
    if (l == RATIO_LEVEL_ABOVE)  return("Above or equal 0.00");
    if (l == RATIO_LEVEL_UNDER)  return("Under 0.05");
  //--- Got this far, so return NA
     return(na);
  }
  string strPrintTelegram(void)
  {
    string msg=nl+">"+ind_name+"<";
    msg = StringConcatenate(msg, strPrintStr( "CR Age",strAgeBar() ));
    msg = StringConcatenate(msg, strPrintStr( "CR Ratio",strRatioLevel() ));
    return( msg );    
  }
};
