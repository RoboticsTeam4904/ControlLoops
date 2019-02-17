class Elevator {
  public float y;
  public float pastY;
  public float yVel;
  public float pastYVel;
  public float yAcc;
  public float MAX_HEIGHT;
  public float MIN_HEIGHT;
  
  float SIZE;
  float NOISE;
  float VEL_LIMIT;
  float ACC_LIMIT;
  float GRAVITY;
  
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
    this.GRAVITY = 0.981;
  }
  
  public Boolean isFinished(float target) {
    return (abs(yVel) <= 1 && abs(target - this.y) <= 5);
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
    this.pastYVel = this.yVel;
    this.yVel += this.yAcc /*+ random(-NOISE,NOISE)*/ + GRAVITY;
    this.pastY = this.y;
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
  float error;
  float yErrorSum;
  
  ElevatorPID(float p, float i, float d) {
    this.p = p;
    this.i = i;
    this.d = d;
    this.error = -1;
    this.yErrorSum = 0;
  }
 
  public float updateY(float currentY, float pastY, float targetY) {
    this.error = targetY-currentY;
    this.yErrorSum += this.error;
    return this.error*this.p - (currentY-pastY)*this.d + this.yErrorSum*this.i;
  }
}

class PIDNeuralNetwork extends ElevatorPID {
  float yPIDError;
  float yPIDErrorSum;
  float PIDSum;
  float pastPIDSum;
  float yVsV; // needs better name?
  
  float pSum;
  float iSum;
  float dSum;
  
  float[] bestPIDConstants;
  float bestTime;
  
  float partialDerivativeP;
  float partialDerivativeI;
  float partialDerivativeD;
  
  float learningRate;
  
  PIDNeuralNetwork(float p, float i, float d) {
      super(p, i, d);
      this.yPIDError = 0;
      this.yPIDErrorSum = 0;
      this.yVsV = 0;
      this.pSum = 0;
      this.iSum = 0;
      this.dSum = 0;
      //this.bestPIDConstants[0] = p;
      //this.bestPIDConstants[1] = i;
      //this.bestPIDConstants[2] = d;
      //this.bestTime = pow(10,10);
      
      this.learningRate = 0.04904;
  }
  
  public void updateYP(float currentY,float pastY,float targetY) {
    this.error = targetY-currentY;
    this.pastPIDSum = this.PIDSum;
    this.PIDSum = this.error*this.p - (currentY-pastY)*this.d + this.yErrorSum*this.i;
    this.yVsV = (this.error *
                ((currentY-pastY)/(this.PIDSum-this.pastPIDSum)) *
                this.error);
    this.pSum += this.yVsV;
    this.partialDerivativeP = -2/time * this.pSum;
  }
  
  public void updateYI(float currentY,float pastY,float targetY) {
    this.error = targetY-currentY;
    this.yErrorSum += this.error;
    this.pastPIDSum = this.PIDSum;
    this.PIDSum = this.error*this.p - (currentY-pastY)*this.d + this.yErrorSum*this.i;
    this.yVsV = (this.error *
                ((currentY-pastY)/(this.PIDSum-this.pastPIDSum)) *
                this.yErrorSum);
    this.iSum += this.yVsV;
    this.partialDerivativeI = -2/time * this.iSum;
  }
  
  public void updateYD(float currentY,float pastY,float targetY) {
    this.error = targetY-currentY;
    this.pastPIDSum = this.PIDSum;
    this.PIDSum = this.error*this.p - (currentY-pastY)*this.d + this.yErrorSum*this.i;
    this.yVsV = (this.error *
                (currentY-pastY)/(this.PIDSum-this.pastPIDSum) *
                (currentY-pastY));
    this.dSum += this.yVsV;
    this.partialDerivativeD = -2/time * this.dSum;
  }
  
  public void updateConstants() {
    this.p -= this.learningRate * this.partialDerivativeP;
    this.i -= this.learningRate * this.partialDerivativeI;
    this.d -= this.learningRate * this.partialDerivativeD;
  }
}

float target = 500;
int time = 0;
int frameRate = 1000;

Elevator testElevator = new Elevator(200);
PIDNeuralNetwork elevatorTestPID = new PIDNeuralNetwork(0.02, 0.0005, 0.04);

/* called once at the start of the program */
void setup() {
 
  size(1000,1000);
  background(255);
  frameRate(frameRate);
}

/* runs every frame */
void draw() {
  
  if (!(testElevator.isFinished(target))) {
    background(255);
    testElevator.tune(elevatorTestPID.updateY(testElevator.y, testElevator.pastY, target));
    testElevator.update();
  }
  else {
    println(float(time)/frameRate);
    elevatorTestPID.updateConstants();
    testElevator.y = 200; 
    time = 0;
  }
  testElevator.display();
  text("Time: "+(float(time)/frameRate), 800, 780);
  time += 1;
}
