#property copyright "Copyright 2019, Dennis Lee"
#property link      "https://github.com/dennislwm/FX-Style"
#property strict

#define na "NA"
#define nl "\n"

//--- The base class CStyleAbtest
class CStyleAbtest
{
public:
//--- available globally
//--- constructor
  CStyleAbtest(void){return;}
  virtual void Init(int p, string s){return;}
  virtual void DeInit(void){return;}
  virtual void IndicatorValues(void){return;}

//--- virtual means override possible
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
};