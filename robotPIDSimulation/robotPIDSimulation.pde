class Robot {
  public float x;
  public float y;
  public float pastX;
  public float pastY;
  public float xVel;
  public float yVel;
  public float xAcc;
  public float yAcc;
  
  float SIZE;
  float NOISE;
  float VEL_LIMIT;
  float ACC_LIMIT;
  float GRAVITY;
  float MASS;
  float FRICTION_COEFF;
  
  float F_NORMAL;
  float F_FRICTION;
  
  Robot(float x, float y) {
    this.x = x;
    this.y = y;
    this.pastX = x;
    this.pastY = y;
    this.xVel = 0;
    this.yVel = 0;
    this.xAcc = 0;
    this.yAcc = 0;
    
    // Arbitrary numbers for now
    this.SIZE = 50;
    this.NOISE = 0.1;
    this.VEL_LIMIT = 30;
    this.ACC_LIMIT = 5;
    this.GRAVITY = 0.981;
    this.MASS = 1;
    this.FRICTION_COEFF = 0.96;
    
    this.F_NORMAL = this.GRAVITY * this.MASS;
    this.F_FRICTION = this.F_NORMAL * this.FRICTION_COEFF;
  }
  float is_negative(float value) {
    if (value > 0) {
      return 1;
    }
    else if (value < 0) {
      return -1;
    }
    else {
      return 0;
    }
  }
  /* draws the robot on the canvas */
  public void display() {
    fill(color(0,0,0));
    stroke(0,0,0);
    rect(this.x, this.y, this.SIZE, this.SIZE);
    
    text("Position: ("+int(this.x)+","+int(this.y)+")", 800, 750);
    text("Velocity: ("+int(this.xVel)+","+int(this.yVel)+")", 800, 760);
    text("Acceleration: ("+int(this.xAcc)+","+int(this.yAcc)+")", 800, 770);
  }
  
  /* moves the robot every frame */
  public void update(int width, int height) {
    this.xVel += (
                  this.xAcc +
                  random(-NOISE,NOISE) -
                  (this.is_negative(this.xVel)*this.F_FRICTION)
                  );
    this.pastX = this.x;
    this.x += this.xVel;
    
    this.yVel += (
                  this.yAcc +
                  random(-NOISE,NOISE) -
                  (this.is_negative(this.yVel)*this.F_FRICTION)
                  );
    this.pastY = this.y;
    this.y += this.yVel;
    
    // can't go past edges of screen
    if (this.x > width) {
      this.x = width;
    }
    else if (this.x < 0) {
      this.x = 0;
    }
    if (this.y > height) {
      this.y = height;
    }
    else if (this.y < 0) {
      this.y = 0;
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
  
  /* accelerates towards target acceleration */
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

/* calculates acceleration given error */
class PID {
  float p;
  float i;
  float d;
  float f;
  float error;
  float xErrorSum;
  float yErrorSum;
  
  PID(float p, float i, float d, float f) {
    this.p = p;
    this.i = i;
    this.d = d;
    this.f = f;
    this.error = -1;
    this.xErrorSum = 0;
    this.yErrorSum = 0;
  }
  public float updateX(float currentX, float pastX, float targetX) {
    this.error = targetX-currentX;
    this.xErrorSum += this.error;
    return this.error*this.p - (currentX-pastX)*this.d + this.xErrorSum*this.i;
  }
  
  public float updateY(float currentY, float pastY, float targetY) {
    this.error = targetY-currentY;
    this.yErrorSum += this.error;
    return this.error*this.p - (currentY-pastY)*this.d + this.yErrorSum*this.i;
  }
}

class PIDNeuralNetwork extends PID {
  float xPIDError;
  float yPIDError;
  float xPIDErrorSum;
  float yPIDErrorSum;
  
  PIDNeuralNetwork(float p, float i, float d, float f) {
      super(p, i, d, f);
      xPIDError = 0;
      yPIDError = 0;
      xPIDErrorSum = 0;
      yPIDErrorSum = 0;
    }
  
  public float updateX(float currentX, float targetX) {
    this.error = targetX-currentX;
    this.xPIDError = this.error * this.error;
    this.xPIDErrorSum +=  this.xPIDError;
    return this.xPIDErrorSum;
  }
  
  public float updateY(float currentY, float targetY) {
    this.error = targetY-currentY;
    this.yPIDError = this.error * this.error;
    this.yPIDErrorSum +=  this.yPIDError;
    return this.yPIDErrorSum;
  }
  
  public void updateConstants(float p, float i, float d) {
    this.p = p;
    this.i = i;
    this.d = d;
  }
}

Robot testRobot = new Robot(100, 100);
PID testPID = new PID(0.02, 0.0005, 0.04, 0);

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
  testRobot.tune(
                 testPID.updateX(testRobot.x, testRobot.pastX, 500),
                 testPID.updateY(testRobot.y, testRobot.pastY, 300)
                 );
  testRobot.update(width, height);
  testRobot.display();
}
