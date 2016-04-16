public class PictureJob implements Runnable {
  Thread thread;

  public PictureJob(PApplet parent) {
    parent.registerMethod("stop", this);
  }

  public void start() {
    thread = new Thread(this);
    thread.start();
  }

  public void run() {

  for (int n=0; n < NUM_TRANSFORMS; n++){
    Transform cls = TRANSFORM_CHOICES[(int)random(TRANSFORM_CHOICES.length)];
    addTransform(cls);
  }

  for (int i=0;i<NUM_POINTS;i++){
    println("Render: "+((float)i/NUM_POINTS)*100.0);
    double px = random(-1, 1);
    double py = random(-1, 1);
    color c = color(1.0, 1.0, 1.0);
    
    for (int j = 0; j < ITERATIONS; j++){
        Transform t = choose();
        //println("Transform: "+t);
        PVectorDouble p = t.transform(px, py);
        c = t.transformColor(c);
        PVectorDouble f = finalTransform(p.x, p.y);
        int x = int(((float)f.x + 1) * WIDTH / 2);
        int y = int(((float)f.y + 1) * HEIGHT / 2);
        result.addRadiance(x, y, c);
        px = p.x;
        py = p.y;
    }
  }
  shiftBlur3x(result.source);
  result.source.save(savePath("data/temp_old.png"));
}

  public void stop() {
    thread = null;
  }

  // this will magically be called by the parent once the user hits stop
  // this functionality hasn't been tested heavily so if it doesn't work, file a bug
  public void dispose() {
    stop();
  }
} 