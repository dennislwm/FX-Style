#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

#define na "NA"
#define nl "\n"

//--- The base class CStyleBuffer
class CStyleBuffer
{
public:
//--- available globally
  int     period;
  string  symbol;
//--- constructor

  CStyleBuffer(void){period=0;symbol=NULL;}
  void Init(int p, string s){period=p;symbol=s;}

//--- virtual means override possible
  virtual bool blnReadIndicatorValues (double& b[]) {return false;} 
  virtual bool blnReadIndicatorValues (double& b1[], double& b2[]) {return false;} 
  virtual string strPrintTelegram(void){
    string msg=nl;
    msg = StringConcatenate(msg, strPrintStr( "Symbol",symbol ));
    msg = StringConcatenate(msg, strPrintStr( "Period",strGetPeriod() ));
    return( msg );    
  }
  
//--- values
  string  strGetPeriod(void)
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
  string strPrintInt(string key, int val)
  {
    return( StringConcatenate(nl,key,"=",val) );
  }
  string strPrintDbl(string key, double val, int dgt=5)
  {
    return( StringConcatenate(nl,key,"=",NormalizeDouble(val,dgt)) );
  }
  string strPrintTme(string key, datetime val)
  {
    return( StringConcatenate(nl,key,"=",TimeToString(val)) );
  }
  string strPrintStr(string key, string val)
  {
    return( StringConcatenate(nl,key,"=",val) );
  }
  string strPrintBln(string key, bool val)
  {
    string valType;
    if( val )   valType="true";
    else        valType="false";
    return( StringConcatenate(nl,key,"=",valType) );
  }  
};