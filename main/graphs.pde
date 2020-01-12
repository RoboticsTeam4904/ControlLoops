class Grapher {
  
  float target;
  
  float scale = 3;
  
  ArrayList<Float> points;
  
  Grapher(float target) {
    this.target = target;
    points = new ArrayList<Float>();
  }
  
  void addPoint(float y) {
    points.add(y);
  }
  
  int ftopos(float f) {
    return 450 - (int) f;
  }
  
  void display() {  
    //draws the motor
    fill(255,255,255);
    rect(50, 350, 400, 100);
    stroke(0, 255, 0);
   
    line(50, 450 - target, 450, 450 - target);
    
    stroke(0, 0, 0);
    boolean increaseScale = false;
    fill(0, 0, 0);
    for(int i = 0; i < points.size() - 1; i++) {
      line((i*scale)+50, ftopos(points.get(i)), ((i+1)*scale)+50, ftopos(points.get(i+1)));
      if(i*scale + 50 >= 450) {
        increaseScale = true;
      }
    }
    if(increaseScale) {
      scale /= 1.5;
    }
    
    
    textSize(15);
    text("Velocity ", 0, 0);
  }
}
