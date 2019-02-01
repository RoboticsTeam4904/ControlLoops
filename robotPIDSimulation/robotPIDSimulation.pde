class Robot {
  float x;
  float y;
  float xVel;
  float yVel;
  float xAcc;
  float yAcc;
  
  float SIZE;
  
  float NOISE;
  float VEL_LIMIT;
  float ACC_LIMIT;
  
  boolean rolling;

  
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
    
    this.rolling = false;
  }
  
  public void display() {
    fill(color(0,0,0));
    stroke(0,0,0);
    rect(this.x, this.y, this.SIZE, this.SIZE);
    
    text("Position: ("+int(this.x)+","+int(this.y)+")", 250, 550);
    text("Velocity: ("+int(this.xVel)+","+int(this.yVel)+")", 250, 560);
    text("Acceleration: ("+int(this.xAcc)+","+int(this.yAcc)+")", 250, 570);
  }
  
  public void update(int width, int height) {
    // control with arrows
    
    if (this.rolling) {
      this.xVel += this.xAcc + random(-NOISE,NOISE);
      this.x += this.xVel;
      
      this.yVel += this.yAcc + random(-NOISE,NOISE);
      this.y += this.yVel;
    }
    
    /* Stops the robot if its speed rounds down to zero */
    if (
      abs(this.xAcc) < 0.5 &&
      abs(this.yAcc) < 0.5 &&
      abs(this.xVel) < 0.5 &&
      abs(this.yVel) < 0.5
      )
    {  
      this.rolling = false;
      this.xAcc = 0;
      this.yAcc = 0;
      this.xVel = 0;
      this.yAcc = 0;
    }
    
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
  
  public void accelerate(String dir, float mag) {
    this.rolling = true;
    if (dir == "x") {
      this.xAcc += mag;
    }
    else if (dir == "y") {
      this.yAcc += mag;
    }
  }
}

Robot testRobot = new Robot(100, 100);

/* increments the robot's acceleration (by calling its
"accelerate" method) when keys are pressed */
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

/* called once at the start of the program */
void setup() {
  int width;
  int height;
  
  width = 1000;
  height = 1000;
  
  // so that it doesn't say that the variables aren't used
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
  testRobot.display();
  testRobot.update(width, height);
}
