class TimingGrapher {
  
  
  float startScale = 30;
  
  float scale = startScale;
  
  float sum = 0;
  
  float yScale = 10;
  
  
  public int yPos = 450;
  public int xPos = 50;
  
  ArrayList<Float> points;
  
  
  TimingGrapher() {
    points = new ArrayList<Float>();
  }
  
  void addPoint(float y) {
    points.add(y);
    
    yScale = 100/points.get(0)-1;
  }
  
  int ftopos(float f) {
    
    return (int) (yPos - (yScale *  f));
  }
  
  void display() {  
    strokeWeight(2);
    fill(255,255,255);
    rect(xPos, yPos-100, 400, 100);
    strokeWeight(1);
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
    
    textSize(12);
    
    text("time ", xPos - 35, yPos - 50);
    
    text("iteration ", xPos + 180, yPos + 20);
    
    textSize(15);
  }
}
