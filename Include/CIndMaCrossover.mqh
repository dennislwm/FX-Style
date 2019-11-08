#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

//---- Assert Basic externs
#include <CStyleBuffer.mqh>

class CIndMaCrossover: public CStyleBuffer
{
protected:
//--- available through methods
  ENUM_AGE_BAR      age;
  ENUM_CROSSOVER    cross;
  ENUM_ZONE_PRICE   zone;
  int               size_ma;
  int               size_price;
public:
//--- available globally
  CIndMaCrossover(void):CStyleBuffer(){age=AGE_BAR_NA; cross=CROSSOVER_NA; zone=ZONE_PRICE_NA; size_ma=100; size_price=1; name="MaCrossover";}

  bool blnIndicatorValues (double& b1[], double& b2[], double& b3[])
  {
    int index;
    double fast, slow, price;

  //--- Assert buffer is valid
    if( b1[0]==EMPTY_VALUE ) return false;
    if( b2[0]==EMPTY_VALUE ) return false;
    if( b3[0]==EMPTY_VALUE ) return false;

    fast =b1[0];
    slow =b2[0];
    price=b3[0];

  //--- Assert FastMa relative to SlowMa    
    if( fast >= slow ) 
      cross=CROSSOVER_ABOVE;
    else 
      cross=CROSSOVER_UNDER;

  //--- Assert crossover bar
    for( index=1; index<size_ma-1 ;index++ )
    {
      if( cross==CROSSOVER_ABOVE && b1[index] < b2[index] ) break;
      if( cross==CROSSOVER_UNDER && b1[index] >= b2[index] ) break;
    }
    index=index-1;
    if     ( index <= 1 )    age=AGE_BAR_BORN;
    else if( index <= 2 )    age=AGE_BAR_BABY;
    else if( index <= 3 )    age=AGE_BAR_INFANT;
    else if( index <= 5 )    age=AGE_BAR_TODDLER;
    else if( index <= 8 )    age=AGE_BAR_CHILD;
    else if( index <= 13 )   age=AGE_BAR_TEENAGER;
    else if( index <= 21 )   age=AGE_BAR_ADULT;
    else if( index <= 34 )   age=AGE_BAR_PARENT;
    else if( index <= 55 )   age=AGE_BAR_GRAND;
    else if( index > 55 )    age=AGE_BAR_GREAT;

  //--- Assert close relative to both MAs
    zone = ZONE_PRICE_NA;
    if( cross==CROSSOVER_ABOVE )
    {
      if (price >= fast) zone = ZONE_PRICE_MOMENTUM;
      if (price < fast)  zone = ZONE_PRICE_BETWEEN;
      if (price < slow)  zone = ZONE_PRICE_RETREAT;
    }
    if( cross==CROSSOVER_UNDER )
    {
      if (price < fast)  zone = ZONE_PRICE_MOMENTUM;
      if (price >= fast) zone = ZONE_PRICE_BETWEEN;
      if (price >= slow) zone = ZONE_PRICE_RETREAT;
    }
    
    return true;
  }
  ENUM_AGE_BAR       eAgeBar(void){return age;}
  ENUM_CROSSOVER     eCrossover(void){return cross;}
  ENUM_ZONE_PRICE    eZonePrice(void){return zone;}
  int    intSizeMa(void){return size_ma;}
  int    intSizePrice(void){return size_price;}
};