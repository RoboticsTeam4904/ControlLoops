class TimingGrapher {
  
  
  float startScale = 30;
  
  float scale = startScale;
  
  float sum = 0;
  
  public int yPos = 450;
  public int xPos = 50;
  
  ArrayList<Float> points;
  
  TimingGrapher() {
    points = new ArrayList<Float>();
  }
  
  void addPoint(float y) {
    points.add(y);
  }
  
  int ftopos(float f) {
    return yPos - (int) f;
  }
  
  void display() {  
    //draws the motor
    fill(255,255,255);
    rect(xPos, yPos-100, 400, 100);
    stroke(0, 255, 0);
       
    stroke(0, 0, 0);
    boolean increaseScale = false;
    fill(0, 0, 0);
    for(int i = 0; i < points.size() - 1; i++) {
      line((i*scale)+xPos, ftopos(points.get(i)), ((i+1)*scale)+xPos, ftopos(points.get(i+1)));
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