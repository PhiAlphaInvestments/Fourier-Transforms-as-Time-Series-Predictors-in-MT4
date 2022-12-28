//+------------------------------------------------------------------+
//|                                                          FFT.mqh |
//|                                                      WJBOSS INC. |
//|                                                             None |
//+------------------------------------------------------------------+

#property strict



class Complex {

 
public:

   double real, imag; 
   
   //Complex(void){real= 0; imag=0;}
   Complex(double r = 0, double i = 0) {real = r; imag = i;}

 
  
   Complex operator + (Complex const &obj) {
   Complex res;
   res.real = real + obj.real;
   res.imag = imag + obj.imag;
   return res;
   }
   
    Complex operator - (Complex const &obj) {
    Complex res;
    res.real = real - obj.real;
    res.imag = imag - obj.imag;
    return res;
    }
    

    Complex operator * (Complex const &obj) {
    Complex res;
    res.real = real *obj.real - imag*obj.imag;
    res.imag = real * obj.imag + obj.real*imag;
    return res;
    }

    Complex operator = ( const Complex &r) {
    Complex res;
    res.real = r.real;
    res.imag = r.imag;
    return res;
    }
    Complex(const Complex &r){
    
    
    real = r.real;
    imag = r.imag;
    
    }
    
    

    void print(){
    
    
      if( imag >=0){
         Print( real,"+","i",MathAbs(imag));
      }
    
    
      
      if( imag <0){
         Print( real,"-","i",MathAbs(imag));
      }
    
    }

 
};

Complex Exp( Complex &s){
    
    Complex res;
    
    
    
    
    res.real = MathExp(s.real)*cos(s.imag);
    res.imag = MathExp(s.real)*sin(s.imag);
    
    return res;
    }
    
double Abs(Complex &s){


      return MathSqrt(s.real*s.real +s.imag*s.imag);

}

double Angle(Complex &s){

   if( s.real ==0){
   
      return 0;
   
   }
   



   double arg = MathArctan(s.imag/s.real);
    
    
   
   if( s.imag > 0 && s.real<0){
      
      //Print("passed");
      //pass 
      arg = arg + M_PI;
   
   }
   
   
    if( s.imag < 0 && s.real<0){
   
      //pass 
      arg = arg - M_PI;
   
   }
   
  
   
   return arg;

}

