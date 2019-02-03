class Robot {
  public float x;
  public float y;
  public float xVel;
  public float yVel;
  public float xAcc;
  public float yAcc;
  
  float SIZE;
  
  float NOISE;
  float VEL_LIMIT;
  float ACC_LIMIT;
  
  Robot(float x, float y) {
    this.x = x;
    this.y = y;
    this.xVel = 0;
    this.yVel = 0;
    this.xAcc = 0;
    this.yAcc = 0;
    
    this.SIZE = 50;
    
    // Arbitrary numbers for now
    this.NOISE = 0.1;
    this.VEL_LIMIT = 30;
    this.ACC_LIMIT = 5;
  }
  
  /* draws the robot on the canvas */
  public void display() {
    fill(color(0,0,0));
    stroke(0,0,0);
    rect(this.x, this.y, this.SIZE, this.SIZE);
    
    text("Position: ("+int(this.x)+","+int(this.y)+")", 500, 550);
    text("Velocity: ("+int(this.xVel)+","+int(this.yVel)+")", 500, 560);
    text("Acceleration: ("+int(this.xAcc)+","+int(this.yAcc)+")", 500, 570);
  }
  
  /* moves the robot every frame */
  public void update(int width, int height) {
    this.xVel += this.xAcc; //+ random(-NOISE,NOISE);
    this.x += this.xVel;
    
    this.yVel += this.yAcc; //+ random(-NOISE,NOISE);
    this.y += this.yVel;
    
    // wrap around
    if (this.x > width) {
      this.x = 0;
    }
    else if (this.x < 0) {
      this.x = width;
    }
    if (this.y > height) {
      this.y = 0;
    }
    else if (this.y < 0) {
      this.y = height;
    }
    
    // limit velocity and acceleration
    this.xVel = constrain(this.xVel, -VEL_LIMIT, VEL_LIMIT);
    this.yVel = constrain(this.yVel, -VEL_LIMIT, VEL_LIMIT);
    this.xAcc = constrain(this.xAcc, -ACC_LIMIT, ACC_LIMIT);
    this.yAcc = constrain(this.yAcc, -ACC_LIMIT, ACC_LIMIT);
  }
  
  /* accelerates the robot */
  public void accelerate(float x, float y) {
    this.xAcc += x;
    this.yAcc += y;
  }
  public void tune(float targetXAcc, float targetYAcc) {
    if (this.xAcc > targetXAcc) {
      this.xAcc -= 1;
    }
    else if (this.xAcc < targetXAcc) {
      this.xAcc += 1;
    }
    if (this.yAcc > targetYAcc) {
      this.yAcc -= 1;
    }
    else if (this.yAcc < targetYAcc) {
      this.yAcc += 1;
    }
  }
}

class PID {
  float p;
  float i;
  float d;
  float f;
  
  PID(float p, float i, float d, float f) {
    this.p = p;
    this.i = i;
    this.d = d;
    this.f = f;
  }
  public float update(float x, float y, float targetX, float targetY) {
    return (targetX-x)*p;
  }
}

Robot testRobot = new Robot(100, 100);
PID testPID = new PID(0.2, 0.5, 0.4, 0);

/* increments the robot's acceleration (by calling its "accelerate" method)
when keys are pressed, mostly as a test of physics in the program */
public void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      testRobot.accelerate(-1,0);
    }
    else if (keyCode == RIGHT) {
      testRobot.accelerate(1,0);
    }
    else if (keyCode == UP) {
      testRobot.accelerate(0,-1);
    }
    else if (keyCode == DOWN) {
      testRobot.accelerate(0,1);
    }
  }
}

/* called once at the start of the program */
void setup() {
  int width;
  int height;
  
  width = 1000;
  height = 1000;
  
  // so that Processing doesn't say that the variables aren't used
  println(width);
  println(height);
  
  // can't use variables for size...
  size(1000,1000);
  background(255); 
  frameRate(12);
}

/* runs every frame */
void draw() {
  background(255);
  testRobot.tune(testPID.update(testRobot.x, testRobot.y, 500, 100), 0);
  testRobot.update(width, height);
  testRobot.display();
}
