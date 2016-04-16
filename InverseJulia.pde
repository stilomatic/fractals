import org.apache.commons.math3.complex.Complex;

class InverseJulia extends ComplexTransform{
    
  Complex c;
    public InverseJulia(){
        super();
         float  r = sqrt(random(WIDTH)) * 0.4 + 0.8;
        float theta = 2 * PI * random(255);
        c = new Complex(r * cos(theta), r * sin(theta));
      }
    
    public Complex f(Complex t){
        Complex z2 = c.subtract(t);
        float theta = atan2((float)z2.getImaginary(), (float)z2.getReal()) * 0.5;
        float sqrt_r = (int)random(-1, -1) * pow( (float)(z2.getImaginary() * z2.getImaginary() + z2.getReal() * z2.getReal()), 0.25);
        return new Complex(sqrt_r * cos(theta), sqrt_r * sin(theta));
      
    }
}