import org.apache.commons.math3.complex.Complex;

int WIDTH;
int HEIGHT;
int ITERATIONS = 10000;
int NUM_POINTS = 1000;
int NUM_TRANSFORMS = 10000;

//ASImage result = new ASImage(WIDTH, HEIGHT);
ASImage result;
PictureJob pj;
double total_weight = 0.0;
ArrayList<Box> transforms = new ArrayList<Box>();
Transform [] TRANSFORM_CHOICES = {new MoebiusBase(), new InverseJulia(), new ComplexTransform(), new Moebius(), new Linear()};


void setup(){
  //fullScreen();
  size(2000,1024);
  PImage temp = loadImage("temp_old.png");
  result = new ASImage(temp);
  WIDTH = temp.width;
  HEIGHT = temp.height;
  pj = new PictureJob(this);
  pj.start();
}

void draw(){
  image(result.source,0,0);
}


double log10 (float x) {
  return (double)(log(x) / log(10));
}

void addTransform(Transform transform)
{
       double weight = random(1, 0.15) * random(1, 0.15);
       total_weight += weight;
       transforms.add(new Box(weight, transform));
}

Transform choose()
{
        double w = random((float)total_weight);
        double running_total = 0;
        for (Box p : transforms){
            running_total += p.weight;
            if (w <= running_total)
                //println ("TRANSFORM CHOOSEN");
                return p.transform;
        }
        //println ("TRANSFORM NOT CHOOSEN");
        return transforms.get(0).transform;
}

PVectorDouble finalTransform(double px,double py){
        double a = 0.5;
        double b = 0;
        double c = 0;
        double d = 1;
        Complex z = new Complex(px, py);
        Complex z2 = z.multiply(a).add(b).divide(z.multiply(c).add(d));
        return new PVectorDouble((double)z2.getReal(), (double)z2.getImaginary());
}

Complex getRandomComplex()
{
  return new Complex(random(-1, 1), random(-1, 1));
}

void shiftBlur3x(PImage source){ 
  int yOffset;
  int sWidth = source.width;
  int sHeight = source.height;
  
  int[] s,t;
  
  source.loadPixels();
  s = source.pixels;
  
  t = new int[sWidth* sHeight];
  
  for (int i = 1; i < (sWidth-1); ++i){
    
    yOffset = sWidth*(sHeight-1);
    // top edge (minus corner pixels)
    t[i] = (((((s[i] & 0xFF) * 52) + 
      ((s[i+1] & 0xFF) + 
      (s[i-1] & 0xFF) + 
      (s[i + sWidth] & 0xFF) + 
      (s[i + yOffset] & 0xFF)) * 51) >>> 8)  & 0xFF) +
      (((((s[i] & 0xFF00) * 52) + 
      ((s[i+1] & 0xFF00) + 
      (s[i-1] & 0xFF00) + 
      (s[i + sWidth] & 0xFF00) + 
      (s[i + yOffset] & 0xFF00)) * 51) >>> 8)  & 0xFF00) +
      (((((s[i] & 0xFF0000) * 52) + 
      ((s[i+1] & 0xFF0000) + 
      (s[i-1] & 0xFF0000) + 
      (s[i + sWidth] & 0xFF0000) + 
      (s[i + yOffset] & 0xFF0000)) * 51) >>> 8)  & 0xFF0000) +
      0xFF000000; //ignores transparency

    // bottom edge (minus corner pixels)
    t[i + yOffset] = (((((s[i + yOffset] & 0xFF) * 52) + 
      ((s[i - 1 + yOffset] & 0xFF) + 
      (s[i + 1 + yOffset] & 0xFF) +
      (s[i + yOffset - sWidth] & 0xFF) +
      (s[i] & 0xFF)) * 51) >>> 8) & 0xFF) +
      (((((s[i + yOffset] & 0xFF00) * 52) + 
      ((s[i - 1 + yOffset] & 0xFF00) + 
      (s[i + 1 + yOffset] & 0xFF00) +
      (s[i + yOffset - sWidth] & 0xFF00) +
      (s[i] & 0xFF00)) * 51) >>> 8) & 0xFF00) +
      (((((s[i + yOffset] & 0xFF0000) * 52) + 
      ((s[i - 1 + yOffset] & 0xFF0000) + 
      (s[i + 1 + yOffset] & 0xFF0000) +
      (s[i + yOffset - sWidth] & 0xFF0000) +
      (s[i] & 0xFF0000)) * 51) >>> 8) & 0xFF0000) +
      0xFF000000;    
    
    // central square
    for (int j = 1; j < (sHeight-1); ++j){
      yOffset = j*sWidth;
      t[i + yOffset] = (((((s[i + yOffset] & 0xFF) * 52) +
        ((s[i + 1 + yOffset] & 0xFF) +
        (s[i - 1 + yOffset] & 0xFF) +
        (s[i + yOffset + sWidth] & 0xFF) +
        (s[i + yOffset - sWidth] & 0xFF)) * 51) >>> 8) & 0xFF) +
        (((((s[i + yOffset] & 0xFF00) * 52) +
        ((s[i + 1 + yOffset] & 0xFF00) +
        (s[i - 1 + yOffset] & 0xFF00) +
        (s[i + yOffset + sWidth] & 0xFF00) +
        (s[i + yOffset - sWidth] & 0xFF00)) * 51) >>> 8) & 0xFF00) +
        (((((s[i + yOffset] & 0xFF0000) * 52) +
        ((s[i + 1 + yOffset] & 0xFF0000) +
        (s[i - 1 + yOffset] & 0xFF0000) +
        (s[i + yOffset + sWidth] & 0xFF0000) +
        (s[i + yOffset - sWidth] & 0xFF0000)) * 51) >>> 8) & 0xFF0000) +
        0xFF000000;
    }
  }
  
  // left and right edge (minus corner pixels)
  for (int j = 1; j < (sHeight-1); ++j){
      yOffset = j*sWidth;
      t[yOffset] = (((((s[yOffset] & 0xFF) * 52) +
        ((s[yOffset + 1] & 0xFF) +
        (s[yOffset + sWidth - 1] & 0xFF) +
        (s[yOffset + sWidth] & 0xFF) +
        (s[yOffset - sWidth] & 0xFF) ) * 51) >>> 8) & 0xFF) +
        (((((s[yOffset] & 0xFF00) * 52) +
        ((s[yOffset + 1] & 0xFF00) +
        (s[yOffset + sWidth - 1] & 0xFF00) +
        (s[yOffset + sWidth] & 0xFF00) +
        (s[yOffset - sWidth] & 0xFF00) ) * 51) >>> 8) & 0xFF00) +
        (((((s[yOffset] & 0xFF0000) * 52) +
        ((s[yOffset + 1] & 0xFF0000) +
        (s[yOffset + sWidth - 1] & 0xFF0000) +
        (s[yOffset + sWidth] & 0xFF0000) +
        (s[yOffset - sWidth] & 0xFF0000) ) * 51) >>> 8) & 0xFF0000) +
        0xFF000000;

      t[yOffset + sWidth - 1] = (((((s[yOffset + sWidth - 1] & 0xFF) * 52) +
        ((s[yOffset] & 0xFF) +
        (s[yOffset + sWidth - 2] & 0xFF) +
        (s[yOffset + (sWidth<<1) - 1] & 0xFF) +
        (s[yOffset - 1] & 0xFF)) * 51) >>> 8) & 0xFF) +
        (((((s[yOffset + sWidth - 1] & 0xFF00) * 52) +
        ((s[yOffset] & 0xFF00) +
        (s[yOffset + sWidth - 2] & 0xFF00) +
        (s[yOffset + (sWidth<<1) - 1] & 0xFF00) +
        (s[yOffset - 1] & 0xFF00)) * 51) >>> 8) & 0xFF00) +
        (((((s[yOffset + sWidth - 1] & 0xFF0000) * 52) +
        ((s[yOffset] & 0xFF0000) +
        (s[yOffset + sWidth - 2] & 0xFF0000) +
        (s[yOffset + (sWidth<<1) - 1] & 0xFF0000) +
        (s[yOffset - 1] & 0xFF0000)) * 51) >>> 8) & 0xFF0000) +
        0xFF000000;
  }
  
  // corner pixels
  t[0] = (((((s[0] & 0xFF) * 52) + 
    ((s[1] & 0xFF) + 
    (s[sWidth-1] & 0xFF) + 
    (s[sWidth] & 0xFF) + 
    (s[sWidth*(sHeight-1)] & 0xFF)) * 51) >>> 8)  & 0xFF) +
    (((((s[0] & 0xFF00) * 52) + 
    ((s[1] & 0xFF00) + 
    (s[sWidth-1] & 0xFF00) + 
    (s[sWidth] & 0xFF00) + 
    (s[sWidth*(sHeight-1)] & 0xFF00)) * 51) >>> 8)  & 0xFF00) +
    (((((s[0] & 0xFF0000) * 52) + 
    ((s[1] & 0xFF0000) + 
    (s[sWidth-1] & 0xFF0000) + 
    (s[sWidth] & 0xFF0000) + 
    (s[sWidth*(sHeight-1)] & 0xFF0000)) * 51) >>> 8)  & 0xFF0000) +
    0xFF000000;

  t[sWidth - 1 ] = (((((s[sWidth-1] & 0xFF) * 52) + 
    ((s[sWidth-2] & 0xFF) + 
    (s[0] & 0xFF) + 
    (s[(sWidth<<1) - 1] & 0xFF) + 
    (s[sWidth*sHeight-1] & 0xFF) ) * 51) >>> 8) & 0xFF) +
    (((((s[sWidth-1] & 0xFF00) * 52) + 
    ((s[sWidth-2] & 0xFF00) + 
    (s[0] & 0xFF00) + 
    (s[(sWidth<<1) - 1] & 0xFF00) + 
    (s[sWidth*sHeight-1] & 0xFF00) ) * 51) >>> 8) & 0xFF00) +
    (((((s[sWidth-1] & 0xFF0000) * 52) + 
    ((s[sWidth-2] & 0xFF0000) + 
    (s[0] & 0xFF0000) + 
    (s[(sWidth<<1) - 1] & 0xFF0000) + 
    (s[sWidth*sHeight-1] & 0xFF0000) ) * 51) >>> 8) & 0xFF0000) +
    0xFF000000;

  t[sWidth * sHeight - 1] = (((((s[sWidth*sHeight-1] & 0xFF) * 52) + 
    ((s[sWidth-1] & 0xFF) + 
    (s[sWidth*(sHeight-1)-1] & 0xFF) + 
    (s[sWidth*sHeight-2] & 0xFF) + 
    (s[sWidth*(sHeight-1)] & 0xFF) ) * 51) >>> 8) & 0xFF) +
    (((((s[sWidth*sHeight-1] & 0xFF00) * 52) + 
    ((s[sWidth-1] & 0xFF00) + 
    (s[sWidth*(sHeight-1)-1] & 0xFF00) + 
    (s[sWidth*sHeight-2] & 0xFF00) + 
    (s[sWidth*(sHeight-1)] & 0xFF00) ) * 51) >>> 8) & 0xFF00) +
    (((((s[sWidth*sHeight-1] & 0xFF0000) * 52) + 
    ((s[sWidth-1] & 0xFF0000) + 
    (s[sWidth*(sHeight-1)-1] & 0xFF0000) + 
    (s[sWidth*sHeight-2] & 0xFF0000) + 
    (s[sWidth*(sHeight-1)] & 0xFF0000) ) * 51) >>> 8) & 0xFF0000) +
    0xFF000000;
  
  t[sWidth *(sHeight-1)] = (((((s[sWidth*(sHeight-1)] & 0xFF) * 52) + 
    ((s[sWidth*(sHeight-1) + 1] & 0xFF) + 
    (s[sWidth*sHeight-1] & 0xFF) + 
    (s[sWidth*(sHeight-2)] & 0xFF) + 
    (s[0] & 0xFF) ) * 51) >>> 8) & 0xFF) +
    (((((s[sWidth*(sHeight-1)] & 0xFF00) * 52) + 
    ((s[sWidth*(sHeight-1) + 1] & 0xFF00) + 
    (s[sWidth*sHeight-1] & 0xFF00) + 
    (s[sWidth*(sHeight-2)] & 0xFF00) + 
    (s[0] & 0xFF00) ) * 51) >>> 8) & 0xFF00) +
    (((((s[sWidth*(sHeight-1)] & 0xFF0000) * 52) + 
    ((s[sWidth*(sHeight-1) + 1] & 0xFF0000) + 
    (s[sWidth*sHeight-1] & 0xFF0000) + 
    (s[sWidth*(sHeight-2)] & 0xFF0000) + 
    (s[0] & 0xFF0000) ) * 51) >>> 8) & 0xFF0000) +
    0xFF000000;
    
    source.pixels = t;
    source.updatePixels();
}