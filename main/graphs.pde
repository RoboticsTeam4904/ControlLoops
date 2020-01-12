class Grapher {
  
  float target;
  
  float startScale = 3;
  
  float scale = startScale;
  
  float sum = 0;
  
  public int yPos = 450;
  public int xPos = 50;
  
  ArrayList<Float> points;
  
  Grapher(float target) {
    this.target = target;
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
    strokeWeight(2);
    fill(255,255,255);
    rect(xPos, yPos-100, 400, 100);
    strokeWeight(1);
    stroke(0, 255, 0);
   
    line(xPos, yPos - target, xPos + 400, yPos - target);
    
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
    
    textSize(12);
    
    text("v ", xPos - 15, yPos - 45);
    
    text("time ", xPos + 190, yPos + 20);
    
    textSize(15);
  }
}
