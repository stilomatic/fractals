class ASImage
{
 float [] RGB_LUMINANCE = {0.2126, 0.7152, 0.0722};
 float DISPLAY_LUMINANCE_MAX = 200.0;
 float SCALEFACTOR_NUMERATOR = pow(1.219 + (DISPLAY_LUMINANCE_MAX * 0.25), 0.4);
 float GAMMA_ENCODE = 0.45;
 PImage source;
 
 public ASImage(int w, int h){
   source = new PImage(w,h);
 }
 
  public ASImage(PImage img){
    //img.resize(img.width*2, img.height*2);
    source = img;
 }

  public void addRadiance(int x,int y,color radiance){
    if(x>0 && x < source.width ){
       if(y>0 && y < source.height ){
        source.loadPixels();
        color c = source.pixels[x+y*source.width];
        int r = (c >> 16 & 0xFF) + (radiance >> 16 & 0xFF);
        int g = (c >> 8 & 0xFF) + (radiance >> 8 & 0xFF);
        int b = (c & 0xFF) + (radiance & 0xFF);
        source.pixels[x+y*source.width] = color(r,g,b);
        source.updatePixels();
      }
    }
  }
  
  public double getScalefactor(int iterations){
    
        double sum_of_logs = 0.0;

        for (int x=0; x<source.width; x++){
            for (int y=0; y<source.height; y++){
                color c = source.pixels[x*width+y];
                double lum = (c >> 16 & 0xFF) * RGB_LUMINANCE[0];
                lum += (c >> 8 & 0xFF) * RGB_LUMINANCE[1];
                lum += (c & 0xFF) * RGB_LUMINANCE[2];
                lum /= iterations;
                sum_of_logs += log10(max((float)lum, 0.0001));
            }
          }

        float log_mean_luminance = pow(10.0, (float)(sum_of_logs / (source.height * source.width)));

        double scalefactor = (pow(SCALEFACTOR_NUMERATOR / (1.219 + pow(log_mean_luminance, 0.4)), 2.5)) / DISPLAY_LUMINANCE_MAX;

        return scalefactor;
      }
      
      public void render(int iterations){
        double scalefactor = this.getScalefactor(iterations);
        source.loadPixels();
        for (int x=0; x<source.width; x++){
            for (int y=0; y<source.height; y++){
                color c = source.pixels[y*source.width+x];
                float r = getMagic((c >> 16 & 0xFF), iterations, scalefactor);
                float g = getMagic((c >> 8 & 0xFF), iterations, scalefactor);
                float b = getMagic((c & 0xFF), iterations, scalefactor);
                source.pixels[x*source.width+y] = color(r, g, b);
            }
          }
         source.updatePixels();
      }
      
      private float getMagic(int c, int iterations, double scalefactor){
        return pow(max(c * (float)scalefactor / iterations, 0), GAMMA_ENCODE);
      }
}