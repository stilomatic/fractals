import org.apache.commons.math3.complex.Complex;

class Moebius extends ComplexTransform{
    
  Complex pre_a, pre_b, pre_c, pre_d;
    
    public Moebius(){
        super();
        pre_a = getRandomComplex();
        pre_b = getRandomComplex();
        pre_c = getRandomComplex();
        pre_d = getRandomComplex();
    }
    public Complex f(Complex z){
        return z.multiply(pre_a).add(pre_b).divide(z.multiply(pre_c).add(pre_d));
     }
}