class Grapher {
  
  float target;
  
  ArrayList<Float> points;
  
  Grapher(float target) {
    this.target = target;
    points = new ArrayList<Float>();
  }
  
  void addPoint(float y) {
    points.add(y);
  }
  
  void display() {  
    //draws the motor
    fill(255,255,255);
    rect(50, 350, 400, 100);
    stroke(0, 255, 0);
   
    line(50, 400, 450, 400);
    
    stroke(0, 0, 0);
    
    fill(0, 0, 0);
    
    textSize(15);
    text("Velocity ", 0, 0);
  }
}
