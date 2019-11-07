#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

#define na "NA"
#define nl "\n"

//--- The base class CStyleBuffer
class CStyleBuffer
{
private:
   int   nextBarTime;

protected:
//--- available through methods
  int     period;
  string  symbol;
//--- values
  string strPrintInt(string key, int val){return( StringConcatenate(nl,key,"=",val) );}
  string strPrintDbl(string key, double val, int dgt=5){return( StringConcatenate(nl,key,"=",NormalizeDouble(val,dgt)) );}
  string strPrintTme(string key, datetime val){return( StringConcatenate(nl,key,"=",TimeToString(val)) );}
  string strPrintStr(string key, string val){return( StringConcatenate(nl,key,"=",val) );}
  string strPrintBln(string key, bool val)
  {
    string valType;
    if( val )   valType="true";
    else        valType="false";
    return( StringConcatenate(nl,key,"=",valType) );
  }  
public:
//--- constructor

  CStyleBuffer(void){period=0;symbol=NULL;}
  void Init(int p, string s){period=p;symbol=s;}

//--- virtual means override possible
  virtual bool blnIndicatorValues (double& b[]) {return false;} 
  virtual bool blnIndicatorValues (double& b1[], double& b2[]) {return false;} 
  virtual bool blnIndicatorValues (double& b1[], double& b2[], double& b3[]) {return false;} 
  virtual string strPrintTelegram(void){
    string msg=nl;
    msg = StringConcatenate(msg, strPrintStr( "Symbol",symbol ));
    msg = StringConcatenate(msg, strPrintStr( "Period",strPeriod() ));
    return( msg );    
  }
  
//--- values
  bool isNewBar()
  {
    if ( nextBarTime == Time[0] )
      return(false);
    else
      nextBarTime = Time[0];
    return(true);
  }
  int     intPeriod(void){return period;}
  string  strPeriod(void)
  {
    int p = period;
    if (p == PERIOD_M1) return("M1");
    if (p == PERIOD_M5) return("M5");
    if (p == PERIOD_M15) return("M15");
    if (p == PERIOD_M30) return("M30");
    if (p == PERIOD_H1) return("H1");
    if (p == PERIOD_H4) return("H4");
    if (p == PERIOD_D1) return("D1");
    if (p == PERIOD_W1) return("W1");
    if (p == PERIOD_MN1) return("MN1");
  //--- Got this far, so return NA
     return(na);
  }
  string strSymbol(void){return(symbol);}
};

//---- Assert Enums
enum ENUM_AGE_BAR
{
  AGE_BAR_NA,        // NA
  AGE_BAR_BORN,      // == Bar[1], where Bar[0] is current bar
  AGE_BAR_BABY,      // <= Bar[2]
  AGE_BAR_INFANT,    // <= Bar[3]
  AGE_BAR_TODDLER,   // <= Bar[5]
  AGE_BAR_CHILD,     // <= Bar[8]
  AGE_BAR_TEENAGER,  // <= Bar[13]
  AGE_BAR_ADULT,     // <= Bar[21]
  AGE_BAR_PARENT,    // <= Bar[34]
  AGE_BAR_GRAND,     // <= Bar[55]
  AGE_BAR_GREAT      // > Bar[55]
};
enum ENUM_RATIO_LEVEL
{
  RATIO_LEVEL_NA,          // NA
  RATIO_LEVEL_ABOVE,       // Above or equal 0.00
  RATIO_LEVEL_UNDER        // Below 0.00
};
enum ENUM_CROSSOVER
{
  CROSSOVER_NA,          // NA
  CROSSOVER_ABOVE,       // FastMa is above or equal to SlowMa
  CROSSOVER_UNDER        // FastMa is below SlowMa
};
enum ENUM_ZONE_PRICE
{
  ZONE_PRICE_NA,           // NA
  ZONE_PRICE_MOMENTUM,
  ZONE_PRICE_BETWEEN,
  ZONE_PRICE_RETREAT
};
