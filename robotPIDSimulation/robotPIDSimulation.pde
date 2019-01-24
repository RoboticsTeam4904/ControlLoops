class Robot {
  int x;
  int y;
  int xVel;
  int yVel;
  int xAcc;
  int yAcc;
  
  int VEL_LIMIT;
  int ACC_LIMIT;
  
  int SIZE;

  
  Robot(int x, int y) {
    this.x = x;
    this.y = y;
    this.xVel = 0;
    this.yVel = 0;
    this.xAcc = 0;
    this.yAcc = 0;
    
    // Arbitrary numbers for now
    this.VEL_LIMIT = 30;
    this.ACC_LIMIT = 5;
    
    this.SIZE = 50;
  }
  
  public void display() {
    fill(color(0,0,0));
    stroke(0,0,0);
    rect(this.x, this.y, this.SIZE, this.SIZE);
    
    text("Position: ("+this.x+","+this.y+")", 250, 550);
    text("Velocity: ("+this.xVel+","+this.yVel+")", 250, 560);
    text("Acceleration: ("+this.xAcc+","+this.yAcc+")", 250, 570);
  }
  
  public void update() {
    // control with arrows
    
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
    
    // limit velocity and acceleration
    this.xVel = constrain(this.xVel, -VEL_LIMIT, VEL_LIMIT);
    this.yVel = constrain(this.yVel, -VEL_LIMIT, VEL_LIMIT);
    this.xAcc = constrain(this.xAcc, -ACC_LIMIT, ACC_LIMIT);
    this.yAcc = constrain(this.yAcc, -ACC_LIMIT, ACC_LIMIT);
  }
  
  public void accelerate(String dir, int mag) {
    if (dir == "x") {
      this.xAcc += mag;
    }
    else if (dir == "y") {
      this.yAcc += mag;
    }
  }
}

Robot testRobot = new Robot(100, 100);

public void keyPressed() {
    if (key == CODED) {
      if (keyCode == LEFT) {
        testRobot.accelerate("x",-1);
      }
      else if (keyCode == RIGHT) {
        testRobot.accelerate("x",1);
      }
      else if (keyCode == UP) {
        testRobot.accelerate("y",-1);
      }
      else if (keyCode == DOWN) {
        testRobot.accelerate("y",1);
      }
    }
  }

void setup() {
  size(600,600);
  background(255); 
  frameRate(12);
}
void draw() {
  background(255);
  testRobot.display();
  testRobot.update();
}
