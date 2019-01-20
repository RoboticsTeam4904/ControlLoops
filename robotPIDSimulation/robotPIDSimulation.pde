class Robot {
  int x;
  int y;
  int xVel;
  int yVel;
  int xAcc;
  int yAcc;
  
  int SIZE;

  
  Robot(int x, int y) {
    this.x = x;
    this.y = y;
    this.xVel = 0;
    this.yVel = 0;
    this.xAcc = 1;
    this.yAcc = 1;
    this.SIZE = 50;
  }
  
  public void display() {
    fill(color(0,0,0));
    stroke(0,0,0);
    rect(this.x, this.y, this.SIZE, this.SIZE);
    
    text("("+this.x+","+this.y+")", 300, 550);
  }
  
  public void update() {
    this.xVel += this.xAcc;
    this.x += this.xVel;
    
    this.yVel += this.yAcc;
    this.y += this.yVel;
    
    // wrap around
    if (this.x > 600) {
      this.x = 0;
    }
    else if (this.x < 0) {
      this.x = 600;
    }
    if (this.y > 600) {
      this.y = 0;
    }
    else if (this.y < 0) {
      this.y = 600;
    }
    
    // limit x and y speed
    //if (this.xVel > 20) {
    //  this.xVel = 20;
    //}
    //if (this.yVel > 20) {
    //  this.yVel = 20;
    //}
    //if (key == CODED) {
    //  //println("press");
    //  //this.x += 1;
    //  if (keyCode == LEFT) {
    //    println("LEFT");
    //    this.x -= 1;
    //  }
    //  else if (keyCode == RIGHT) {
    //    println("RIGHT");
    //    this.x += 1;
    // }
    //}      
  }
}

Robot myRobot = new Robot(100, 100);

void setup() {
  size(600,600);
  background(255); 
  frameRate(12);
}
void draw() {
  background(255);
  myRobot.display();
  myRobot.update();
}
