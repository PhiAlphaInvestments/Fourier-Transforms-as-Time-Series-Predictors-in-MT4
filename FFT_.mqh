//+------------------------------------------------------------------+
//|                                                          FFT.mqh |
//|                                                      WJBOSS INC. |
//|                                                             None |
//+------------------------------------------------------------------+
  
#property strict

#include <Complex.mqh>


class FFTvalues{

   private:
      Complex m_values[];
      
   public:
      FFTvalues(){};
      FFTvalues( double &InputValues[]){ 
      
      int Size = ArraySize(InputValues);
      ArrayResize(m_values,Size);
      
         for(int i = 0 ; i<Size; i++){
            double real =InputValues[i];   
            Complex res(real,0);

            m_values[i].real=  res.real;
            m_values[i].imag=  res.imag;
         }
         
      }
      void Set(int index, Complex &number){
      
      m_values[index].real = number.real;
      m_values[index].imag = number.imag;
      
      }
      void Dump(){
      
      
      for( int i =0 ;i < ArraySize(m_values) ; i++){
      
            m_values[i].print();
      
      }
      
      
      }
      void SetSize(int size){
      
            ArrayResize(m_values,size);
      
      }
      int Size() const{
      int Size = ArraySize(m_values);
      return Size;
      }
      
      
      
      Complex operator[](const int i) const{
            
            return(m_values[i]);
      
      } 
      
      void operator=(const FFTvalues &val){
      
      int Size = val.Size();
      ArrayResize(m_values,Size);
      for( int i = 0 ; i<Size;i++){
      
      
      m_values[i].real = val[i].real;
      m_values[i].imag = val[i].imag;
      
      }
      
      } 
       
      FFTvalues(const FFTvalues &val){
      
     
     
      int Size = val.Size();
      ArrayResize(m_values,Size);
      for( int i = 0 ; i<Size;i++){
      
      m_values[i].real = val[i].real;
      m_values[i].imag = val[i].imag;
      }
      
      
      
      
      }
  
  


};


class FFT{

      private:
      FFTvalues IFFT_Calculate_Inner(FFTvalues &InputValues);

      public:
      FFT(){}
      FFTvalues FFT_Calculate(FFTvalues &InputValues);
      FFTvalues IFFT_Calculate(FFTvalues &InputValues);
      FFTvalues FFT_Calculate_Prediction(FFTvalues &InputValues , int NumberOfPRedictions);
      double    Covariance(FFTvalues &X,FFTvalues &Y);
      double    variance(FFTvalues &Y);
      FFTvalues FFT_Freq(int n);
       

};



FFTvalues FFT::FFT_Calculate_Prediction(FFTvalues &InputValues,int NumberOfPRedictions){
      
            
            int n = InputValues.Size();
            int n_harm = n-2;
            
            
            FFTvalues t;
            t.SetSize(n);
            for( int i = 0 ; i <n;i++){
               
                  Complex Num(i,0);
                  
                  t.Set(i,Num);
            
            }
            
            
            double Beta = Covariance( InputValues,t)/variance(t);
            //Print(  "Beta"  ,Beta);
            FFTvalues x_notrend;
            x_notrend.SetSize(n);
            

             for( int i = 0 ; i <n;i++){
               
                  Complex Num(InputValues[i].real - Beta*t[i].real,0);
                  
                  
                  
                  x_notrend.Set(i,Num);
            
            }
            ///######################### good ^^^^^^
            //x_notrend.Dump();  
            
            FFTvalues x_freqdom = FFT_Calculate(x_notrend);
            ///######################### good ^^^^^^
            //x_freqdom.Dump();
            //Print("----");
            
            FFTvalues f         = FFT_Freq(n);
            
            //f.Dump();
            
            FFTvalues new_t;
            
            
            
            new_t.SetSize(n+NumberOfPRedictions);
            for( int i = 0 ; i <n+NumberOfPRedictions;i++){
               
                  Complex Num(double(i),0);
                  
                  new_t.Set(i,Num);
            
            }
            
            //new_t.Dump();
            
            
            
            FFTvalues restored_sig;
            restored_sig.SetSize(new_t.Size());
            //restored_sig.Dump();
            for( int i = 0 ; i < n_harm+1; i++){
            
                  //Print(i,"<=====");
                  
                  double ampli = Abs(x_freqdom[i])/double(n);
                  double phase = Angle(x_freqdom[i]);
                  
                  FFTvalues temp;
                  temp.SetSize(new_t.Size());
                  
                  for( int j = 0 ; j <new_t.Size(); j++){
                  
                     
                     Complex Num( ampli*cos(2*M_PI*f[i].real*new_t[j].real +phase),0);
                     
                     temp.Set(j,Num);
                     
                     restored_sig.Set(j,restored_sig[j] + temp[j]);
                  
                  
                  }
                  //restored_sig.Dump();
                
            
            
            }
            
            
            for( int i = 1 ; i < n_harm+1; i++){
                  
                  int i_ = n -i -1;
                  //Print(i_,"<=====");
                  double ampli = Abs(x_freqdom[i_])/double(n);
                  double phase = Angle(x_freqdom[i_]);
                  
                  FFTvalues temp;
                  temp.SetSize(new_t.Size());
                  
                  for( int j = 0 ; j <new_t.Size(); j++){
                  
                     
                     Complex Num( ampli*cos(2*M_PI*f[i_].real*new_t[j].real +phase),0);
                     
                     temp.Set(j,Num);
                     
                     restored_sig.Set(j,restored_sig[j] + temp[j]);
                  
                  
                  }
                  //restored_sig.Dump();
            
            
            
            }
            
           
            
            ///// Detrend 
            
            for( int i = 0 ; i < restored_sig.Size() ; i++){
            
              Complex Num( restored_sig[i].real + Beta*new_t[i].real,0);            
            
               restored_sig.Set(i,Num);
            
            }
            
            
            
           
           
            return restored_sig;
}

FFTvalues FFT::FFT_Calculate(FFTvalues &InputValues){
         
      FFTvalues val;

      val = InputValues;
      
      
      
      int N = InputValues.Size();
      
      
      if( N==1){
         
            
            return val;
         
      }
      
  
      FFTvalues P_e;
      FFTvalues P_o;
      
      
      if( N%2 == 0){
      
         
         int even_Size =    (N/2); 
         int odd_Size =    (N/2);
         P_e.SetSize(  even_Size);
         P_o.SetSize( odd_Size);
         
         
         for( int i = 0 ;  i < even_Size;i++){
         
         
            P_e.Set(i, InputValues[2*i]);
         
         
         }
         
         
         for( int i = 0 ; i < odd_Size;i++){
            
            P_o.Set(i, InputValues[2*i+1]);
         
         
         }
      }
      
      
      
      
      if( N%2 == 1){
      
         
         int even_Size =    MathCeil(double(N)/2); 
         int odd_Size =    MathFloor(double(N)/2);
         P_e.SetSize(  even_Size);
         P_o.SetSize( odd_Size);
         
         
         for( int i = 0 ;  i < even_Size;i++){
         
         
            P_e.Set(i, InputValues[2*i]);
         
         
         }
         
         
         for( int i = 0 ; i < odd_Size;i++){
            
            P_o.Set(i, InputValues[2*i+1]);
         
         
         }
      }
      
      
      
      
      FFTvalues y_e;
      FFTvalues y_o;
      
      y_e = FFT_Calculate(P_e);
      y_o = FFT_Calculate(P_o);

      FFTvalues Result;
      
      Result.SetSize(N);
     
      for( int k = 0 ; k <(N/2);k++){
      
         Complex Num(0,(-2*M_PI*double(k))/double(N));
         Complex Omega_k = Exp(Num);
      
         Result.Set(k,  y_e[k] + Omega_k*y_o[k]);
         Result.Set(k+int(N/2),  y_e[k]-Omega_k*y_o[k]);
      
      }
      
      
      
      
      return Result;

}



FFTvalues FFT::IFFT_Calculate_Inner(FFTvalues &InputValues){
     
      FFTvalues val;

      val = InputValues;
      
      
      
      int N = InputValues.Size();
      
      
      if( N==1){
         
            
            return val;
         
      }
      
  
      FFTvalues P_e;
      FFTvalues P_o;
      
      
    
      
         
         int even_Size =    (N/2); 
         int odd_Size =    (N/2);
         P_e.SetSize(  even_Size);
         P_o.SetSize( odd_Size);
         
         
         for( int i = 0 ;  i < even_Size;i++){
         
         
            P_e.Set(i, InputValues[2*i]);
         
         
         }
         
         
         for( int i = 0 ; i < odd_Size;i++){
            
            P_o.Set(i, InputValues[2*i+1]);
         
         
         }
     
      
      
      
      FFTvalues y_e;
      FFTvalues y_o;
      
      y_e = IFFT_Calculate_Inner(P_e);
      y_o = IFFT_Calculate_Inner(P_o);

      FFTvalues Result;
      
      Result.SetSize(N);
     
      for( int k = 0 ; k <(N/2);k++){
      
         Complex Num(0,-1*((2*M_PI*double(k))/double(N)));
         Complex Omega_k = Exp(Num);
      
         Result.Set(k,  y_e[k] + Omega_k*y_o[k]);
         Result.Set(k+N/2,  y_e[k]-Omega_k*y_o[k]);
      
      }
      
      
      
      
      return Result;

}
FFTvalues FFT::IFFT_Calculate(FFTvalues &InputValues){

   FFTvalues Val;
   
   Val = IFFT_Calculate_Inner(InputValues);
   int N = Val.Size();
   
   for( int i = 0 ; i <N ; i++){
   
   Complex Num(Val[i].real/double(N),Val[i].imag/double(N));
   
   Val.Set(i,Num); 
   
   }

   return Val; 

};




double FFT::Covariance(FFTvalues &X,FFTvalues &Y){


      
  double muY = 0;    
   
   
   for( int i = 0 ; i< Y.Size() ; i ++){
   
      
      muY = muY +  Y[i].real; 
   
   
   }
   
   muY = muY/double(Y.Size());


     double muX = 0;    
   
   
   for( int i = 0 ; i< X.Size() ; i ++){
   
      
      muX = muX +  X[i].real; 
   
   
   }
   
   muX = muX/double(X.Size());

   double cov =0;
   
   for( int i = 0 ; i< Y.Size() ; i ++){
   
      
      cov =  cov + (X[i].real - muX)*(Y[i].real - muY) ;
   
   
   }
   cov = cov/double(double(X.Size())-1);
   
   return cov; 

}

double FFT::variance(FFTvalues &Y){


   
  double mu = 0;    
   
   
   for( int i = 0 ; i< Y.Size() ; i++){
   
      
      mu = mu +  Y[i].real; 
   
   
   }
   
   mu = mu/double(Y.Size());

   double var = 0;
   
   
   
   for( int i = 0 ; i< Y.Size() ; i++){
   
      
      var  = var + pow(Y[i].real - mu,2);
   
   
   }
   
   var = var/double(double(Y.Size())-1);
   
   return var; 



}

FFTvalues FFT::FFT_Freq(int n){

      FFTvalues res;
      res.SetSize(n);
      
      
      for( int i = 0 ; i < n ;i++){
         
         //Print(i);
         if( i >= n/2){
         
         Complex Num( -1*(1-i/double(n)),0 );
         
         res.Set(i,Num);
         }
         
         
         if( i < n/2){
         
         Complex Num( i/double(n),0 );
         res.Set(i,Num);   
         }
      
      
      }
      
      

      return res;
}