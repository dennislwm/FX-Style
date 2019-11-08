#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

//---- Assert Basic externs
#include <CStyleBuffer.mqh>

class CIndHistogram: public CStyleBuffer
{
protected:
//--- available through methods
  ENUM_AGE_BAR          age;
  ENUM_HISTOGRAM_LEVEL  hist;
  int                   size_hist;

public:
//--- available globally
  CIndHistogram(void):CStyleBuffer(){age=AGE_BAR_NA; hist=HISTOGRAM_LEVEL_NA; size_hist=56; name="Histogram";}
 
  bool blnIndicatorValues (double& b[])
  {
    int CrIndex;
  //--- Assert buffer is valid
    if( b[0]==EMPTY_VALUE ) return false;

    if( b[0] >= 0.00 ) 
      hist=HISTOGRAM_LEVEL_ABOVE;
    else 
      hist=HISTOGRAM_LEVEL_UNDER;

    for( CrIndex=1; CrIndex<size_hist-1 ;CrIndex++ )
    {
      if( b[CrIndex] >= 0.0 && hist==HISTOGRAM_LEVEL_UNDER ) break;
      if( b[CrIndex] < 0.0 && hist==HISTOGRAM_LEVEL_ABOVE ) break;
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
  ENUM_HISTOGRAM_LEVEL   eHistogramLevel(void){return hist;}
  int    intSizeRatio(void){return size_hist;}
};
