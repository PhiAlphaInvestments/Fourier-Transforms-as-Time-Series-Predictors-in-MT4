//+------------------------------------------------------------------+
//|                                                  Custom MACD.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "Moving Averages Convergence/Divergence"
#property strict
#include <FFT.mqh>
#include <MovingAverages.mqh>
enum Power
{ Strong =128,
  Mid    =64,
  Weak   = 32};
//--- indicator settings
#property  indicator_chart_window
#property  indicator_buffers 1
#property  indicator_color1  Red
#property  indicator_width1  1

//--- indicator parameters
input Power InpDepthOfReturns = Strong;   // Fast EMA Period
input int MA = 20;
double    ExtSignalBuffer[];
//--- right input parameters flag
bool      ExtParameters=false;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   IndicatorDigits(Digits+1);
//--- drawing settings
   SetIndexStyle(0,DRAW_SECTION);
   
   SetIndexDrawBegin(0,InpDepthOfReturns);
//--- indicator buffers mapping
   
   SetIndexBuffer(0,ExtSignalBuffer);
//--- name for DataWindow and indicator subwindow label
   IndicatorShortName("FFT("+IntegerToString(InpDepthOfReturns)+")");
   SetIndexLabel(0,"FFT");
   
//--- check for input parameters
   if(InpDepthOfReturns<=6 )
     {
      Print("Wrong input parameters");
      ExtParameters=false;
      return(INIT_FAILED);
     }
   else
      ExtParameters=true;
//--- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int OnCalculate (const int rates_total,
                 const int prev_calculated,
                 const datetime& time[],
                 const double& open[],
                 const double& high[],
                 const double& low[],
                 const double& close[],
                 const long& tick_volume[],
                 const long& volume[],
                 const int& spread[])
  {
   int i,limit;
//---
   if(rates_total<=InpDepthOfReturns+5 || !ExtParameters)
      return(0);
//--- last counted bar will be recounted
   limit=rates_total-prev_calculated;
   if(prev_calculated>0)
      limit++;
//--- macd counted in the 1-st buffer
   for(i=0; i<10; i++)
      ExtSignalBuffer[i]= FFT_of_Returns(close,i);
//--- signal line counted in the 2-nd buffer
   
//--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+


double FFT_of_Returns(const double &close[],int pos){


    double in_Arr[];
    
    ArrayResize(in_Arr,InpDepthOfReturns);
    
    for( int i = 0; i <InpDepthOfReturns;i++){
    
    
         in_Arr[InpDepthOfReturns -i-1] = close[i+pos] ;
    
    
    
    }  


   FFTvalues InputVals(in_Arr);   


   InputVals.Dump();

   FFT FFtransform;   

   FFTvalues pred;
   
   pred = FFtransform.FFT_Calculate_Prediction( InputVals,10,InpDepthOfReturns-2);
      
      
     // pred.Dump();
     
    
    
    double mu = 0; 
    
    for( int i = 0; i < MA-5; i++){
    
       mu += close[pos+i];
    
    
    }
    
    
    
    for( int i = 0; i < 5; i++){
    
       mu += pred[InpDepthOfReturns+i+1].real ;
    
    
    }
  
    
    
    double FinalPred = pred[InpDepthOfReturns].real ;  //(pred[InpDepthOfReturns+2].real - pred[InpDepthOfReturns+1].real ]    ) ;
    Print(FinalPred);
    return  FinalPred  ;







};

