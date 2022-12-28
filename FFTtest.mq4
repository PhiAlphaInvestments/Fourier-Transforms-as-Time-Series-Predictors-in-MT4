//+------------------------------------------------------------------+
//|                                                      FFTtest.mq4 |
//|                                                      WJBOSS INC. |
//|                                                             None |
//+------------------------------------------------------------------+
#property strict

#include <FFT_.mqh>
#include <Complex.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   FFT FFtransfrom;   


   double val[16] = {669, 592, 664, 1005, 699, 401, 646, 472, 598, 681, 1126, 1260, 562, 491, 714, 530};
//---
   int n_predict = 2;
   
   FFTvalues x(val);
   
   FFTvalues extrapolation;
    
   extrapolation = FFtransfrom.FFT_Calculate_Prediction(x,n_predict);
   
   extrapolation.Dump();
   
   
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
