import org.apache.commons.math3.complex.Complex;

class Transform
{
    int r,g,b;
    
    public Transform(){
        r = (int)random(255);
        g = (int)random(255);
        b = (int)random(255);
    }
    
    public color transformColor(color input){
        int ri = (r + (input >> 16 & 0xFF)) / 2;
        int gi = (g + (input >> 8 & 0xFF)) / 2;
        int bi = (b + (input & 0xFF)) / 2;
        return color(ri,gi,bi);
    }
    
    public Complex f(Complex t){
      return t;
    }
    public PVectorDouble transform(double px,double py){
      return new PVectorDouble(px,py);
    }
}