import org.apache.commons.math3.complex.Complex;

class MoebiusBase extends ComplexTransform{
    Complex pre_a, pre_b, pre_c, pre_d, post_a, post_b, post_c, post_d;
    public MoebiusBase(){
        super();
        pre_a = getRandomComplex();
        pre_b = getRandomComplex();
        pre_c = getRandomComplex();
        pre_d = getRandomComplex();
        post_a = getRandomComplex();
        post_b = getRandomComplex();
        post_c = getRandomComplex();
        post_d = getRandomComplex();
    }
    
    public Complex f(Complex z){
        Complex z1 = z.multiply(pre_a).add(pre_b).divide(z.multiply(pre_c).add(pre_d));
        Complex z2 = z1.multiply(post_a).add(post_b).divide(z1.multiply(post_c).add(post_d));
        
        return z2;
      
    }
}