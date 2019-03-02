class Elevator {
  public float y;
  public float pastY;
  public float yVel;
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
    this.pastY = y;
    this.yVel = 0;
    this.yAcc = 0;
    this.MAX_HEIGHT = 800;
    this.MIN_HEIGHT = 200;
    this.SIZE = 50;
    
    // Arbitrary numbers for now
    this.NOISE = 0.1;
    this.VEL_LIMIT = 30;
    this.ACC_LIMIT = 5;
    this.GRAVITY = 0.0981;
  }
  
  public Boolean isFinished(float target) {
    return (abs(yVel) <= 0.5 && abs(target - this.y) <= 1) || time > 1000;
  }
  
  /* draws the robot on the canvas */
  public void display() {
    fill(color(0,0,0));
    stroke(0,0,0);
    rect(250, this.y, this.SIZE, this.SIZE);
    
    fill(color(0,255,0));
    rect(270, target, 10, 10);
    fill(color(0,0,0));
    text("Position: "+int(this.y), 800, 750);
    text("Velocity: "+int(this.yVel), 800, 760);
    text("Acceleration: "+int(this.yAcc), 800, 770);
  }
  
  /* moves the robot every frame */
  public void update() {
    this.yVel += this.yAcc /*+ random(-NOISE,NOISE) + GRAVITY*/;
    this.pastY = this.y;
    this.y += this.yVel;
    //println("Velocity", this.yVel);
    
    //this.y = constrain(this.y, this.MIN_HEIGHT, this.MAX_HEIGHT);
    
    // limit velocity and acceleration
    this.yVel = constrain(this.yVel, -this.VEL_LIMIT, this.VEL_LIMIT);
    this.yAcc = constrain(this.yAcc, -this.ACC_LIMIT, this.ACC_LIMIT);
  }
  
  /* accelerates the robot */
  public void accelerate(float y) {
    this.yAcc += y;
  }
  public void tune(float targetYAcc) {
   
    //if (this.yAcc > targetYAcc) {
    //  this.yAcc -= 0.5;
    //}
    //else if (this.yAcc < targetYAcc) {
    //  this.yAcc += 0.5;
    //}
    
    yAcc = targetYAcc;
  }
  public void reset() {
    this.y = 200;
    this.pastY = 200;
    this.yVel = 0;
    this.yAcc = 0;
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
    this.yErrorSum = 0;
  }
 
  public float updateY(float currentY, float pastY, float targetY) {
    this.error = targetY-currentY;
    this.yErrorSum += this.error;
    return this.error*this.p - (currentY-pastY)*this.d + this.yErrorSum*this.i;
  }
}

class PIDNeuralNetwork extends ElevatorPID {
  float PIDSum;
  float pastPIDSum;
  float summationTerm;
  
  float pSum;
  float iSum;
  float dSum;
  
  float partialDerivativeP;
  float partialDerivativeI;
  float partialDerivativeD;
  
  float pLearningRate;
  float iLearningRate;
  float dLearningRate;
  
  boolean firstRun;
  
  PIDNeuralNetwork(float p, float i, float d) {
    super(p, i, d);
    
    this.summationTerm = 0;
    this.PIDSum = 1;
    this.pastPIDSum = 0;
    
    this.pSum = 0;
    this.iSum = 0;
    this.dSum = 0;
    
    this.pLearningRate = 0.4904 * pow(10,-8);
    this.iLearningRate = 0.4904 * pow(10,-9);
    this.dLearningRate = 0.1904 * pow(10,-5);
    
    this.firstRun = true;
  }
  
  public void sum(float currentY,float pastY) {
    //println("Error sum:", this.yErrorSum);
    this.pastPIDSum = this.PIDSum;
    this.PIDSum = this.error*this.p - (currentY-pastY)*this.d + this.yErrorSum*this.i;
  }
  
  public void updateYP(float currentY,float pastY) {
    this.summationTerm = (this.error *
                ((currentY-pastY)/(this.PIDSum-this.pastPIDSum)) *
                this.error);
    this.pSum += this.summationTerm;
    this.partialDerivativeP = (-2/time) * this.pSum;
  }
  
  public void updateYI(float currentY,float pastY) {
    this.summationTerm = (this.error *
                ((currentY-pastY)/(this.PIDSum-this.pastPIDSum)) *
                this.yErrorSum);
    this.iSum += this.summationTerm;
    this.partialDerivativeI = (-2/time) * this.iSum;
  }
  
  public void updateYD(float currentY,float pastY) {
    this.summationTerm = (this.error *
                (currentY-pastY)/(this.PIDSum-this.pastPIDSum) *
                (currentY-pastY));
    this.dSum += this.summationTerm;
    this.partialDerivativeD = (-2/time) * this.dSum;
  }
  
  public void reset() {
    this.pSum = 0;
    this.iSum = 0;
    this.dSum = 0;
    
    this.PIDSum = 0;
    this.pastPIDSum = 0;
    
    this.firstRun = true;
  }
  
  public void updateConstants() {
    println("Old Constants", this.p, this.i, this.d);
    this.p -= this.pLearningRate * this.partialDerivativeP;
    this.i -= this.iLearningRate * this.partialDerivativeI;
    this.d -= this.dLearningRate * this.partialDerivativeD;
    
    println(
            "Partial Derivatives",
            this.partialDerivativeP,
            this.partialDerivativeI,
            this.partialDerivativeD
           );
    println("New Constants", this.p, this.i, this.d);
    println(" ");
    
    //this.p = constrain(abs(this.p), 0.001, 1);
    //this.i = constrain(abs(this.i), 0.00001, 1);
    //this.d = constrain(abs(this.d), 0.001, 1);
  }
}

float target = 203;
public float time = 0;
int frameRate = 100;

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
  time += 1;
  if (!(testElevator.isFinished(target))) {
    background(255);
    testElevator.tune(elevatorTestPID.updateY(testElevator.y, testElevator.pastY, target));
    testElevator.update();
    elevatorTestPID.sum(testElevator.y, testElevator.pastY);
    if (elevatorTestPID.firstRun) {
      elevatorTestPID.firstRun = false;
    } else {
      elevatorTestPID.updateYP(testElevator.y, testElevator.pastY);
      elevatorTestPID.updateYI(testElevator.y, testElevator.pastY);
      elevatorTestPID.updateYD(testElevator.y, testElevator.pastY);
    }
  } else {
    println("Time Taken: ", time);
    elevatorTestPID.updateConstants();
    elevatorTestPID.reset();
    testElevator.reset();
    time = 0;
  }
  testElevator.display();
  text("Time: "+time, 800, 780);
}
