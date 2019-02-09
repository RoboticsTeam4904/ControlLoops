class Elevator {
  public float y;
  public float yVel;
  public float yAcc;
  public float MAX_HEIGHT;
  public float MIN_HEIGHT;
  
  float SIZE;
  
  float NOISE;
  float VEL_LIMIT;
  float ACC_LIMIT;
  
  Elevator(float y) {
    this.y = y;
    this.yVel = 0;
    this.yAcc = 0;
    this.MAX_HEIGHT = 800;
    this.MIN_HEIGHT = 200;
    
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
    rect(250, this.y, this.SIZE, this.SIZE);
    
    text("Position: "+int(this.y), 800, 750);
    text("Velocity: "+int(this.yVel), 800, 760);
    text("Acceleration: "+int(this.yAcc), 800, 770);
  }
  
  /* moves the robot every frame */
  public void update() {
 
    this.yVel += this.yAcc + random(-NOISE,NOISE);
    this.y += this.yVel;
    
    if (this.y > this.MAX_HEIGHT) {
      this.y = MAX_HEIGHT;
    }
    else if (this.y < this.MIN_HEIGHT) {
      this.y = MIN_HEIGHT;
    }
    
    // limit velocity and acceleration
    this.yVel = constrain(this.yVel, -VEL_LIMIT, VEL_LIMIT);
    this.yAcc = constrain(this.yAcc, -ACC_LIMIT, ACC_LIMIT);
  }
  
  /* accelerates the robot */
  public void accelerate(float y) {
    this.yAcc += y;
  }
  public void tune(float targetYAcc) {
   
    if (this.yAcc > targetYAcc) {
      this.yAcc -= 0.5;
    }
    else if (this.yAcc < targetYAcc) {
      this.yAcc += 0.5;
    }
  }
}


class ElevatorPID {
  float p;
  float i;
  float d;
  float f;
  float error;
  float yErrorSum;
  
  ElevatorPID(float p, float i, float d, float f) {
    this.p = p;
    this.i = i;
    this.d = d;
    this.f = f;
    this.error = -1;
    this.yErrorSum = 0;
  }
 
  public float updateY(float currentY, float pastY, float targetY) {
    this.error = currentY-targetY;
    this.yErrorSum += this.error;
    return this.error*this.p - (currentY-pastY)*this.d;
  }
}

Elevator testElevator = new Elevator(100);
ElevatorPID elevatorTestPID = new ElevatorPID(0.02, 0.05, 0.04, 0);

/* increments the robot's acceleration (by calling its "accelerate" method)
when keys are pressed, mostly as a test of physics in the program */
public void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      testElevator.accelerate(-1);
    }
    else if (keyCode == DOWN) {
      testElevator.accelerate(1);
    }
  }
}

/* called once at the start of the program */
void setup() {
 
  size(1000,1000);
  background(255); 
  frameRate(12);
}

/* runs every frame */
void draw() {
  background(255);
  testElevator.tune(
                 elevatorTestPID.updateY(testElevator.y, 200, testElevator.yVel)
                 );
  testElevator.update();
  testElevator.display();
}
