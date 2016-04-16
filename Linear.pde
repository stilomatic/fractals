class Linear extends Transform
{
  
  double a,b,c,d;
  
   public Linear(){
        super();
        a = random(-1, 1);
        b = random(-1, 1);
        c = random(-1, 1);
        d = random(-1, 1);
    }
            
    public PVectorDouble transform(double px,double py){
        return new PVectorDouble(a * px + b * py, c * px + d * py);
    }
}