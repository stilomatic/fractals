import org.apache.commons.math3.complex.Complex;

class ComplexTransform extends Transform {
    
    public PVectorDouble transform(double px, double py){
        Complex z = new Complex(px, py);
        Complex z2 = f(z);
        return new PVectorDouble((double)z2.getReal(), (double)z2.getImaginary());
    }
        
}