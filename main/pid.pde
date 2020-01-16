/* Implements a PID control loop */
class PID {
  float p;
  float i;
  float d;
  float timeStep;
  float error;
  float errorSum;
  ArrayList<float[]> pastVals = new ArrayList<float[]>();
  
PID(float p, float i, float d, float timeStep) {
    this.p = p;
    this.i = i;
    this.d = d;
    this.timeStep = timeStep;
    this.errorSum = 0;
  }
 
  public float update(float current, float last, float target) {
    this.error = target-current;
    this.errorSum += this.error*this.timeStep;
    //println(this.error*this.p);
    //println(this.error*this.p - (current-last)*this.d + this.errorSum*this.i);
    
    return this.error*this.p - (current-last)*this.d + this.errorSum*this.i;
  }
}


class PIDAutoTuner extends PID {
  float PIDSum;
  float pastPIDSum;
  float summationTerm;
  float yDiff;
  float PIDAccDiff;
  
  float pSum;
  float iSum;
  float dSum;
  
  float partialDerivativeP;
  float partialDerivativeI;
  float partialDerivativeD;
    
  float pLearningRate;
  float iLearningRate;
  float dLearningRate;
  
  PIDAutoTuner(float p, float i, float d, float timeStep) {
    super(p, i, d, timeStep);
    
    this.PIDSum = 1;
    this.pastPIDSum = 0;
    this.summationTerm = 0;
    this.yDiff = 1;
    this.PIDAccDiff = 1;
    
    this.pSum = 0;
    this.iSum = 0;
    this.dSum = 0;
        
    this.partialDerivativeP = 0;
    this.partialDerivativeI = 0;
    this.partialDerivativeD = 0;
    
    this.pLearningRate = 0.4904 * pow(10,-7);
    this.iLearningRate = 0.4904 * pow(10,-9);
    this.dLearningRate = 0.4904 * pow(10,-4.5);
  }
  
  /* called every frame */
  public void sum(float currentY,float pastY) {
    this.yDiff = currentY-pastY;
    this.PIDAccDiff = this.PIDSum-this.pastPIDSum;
    
    //println(this.yDiff);
    //println(this.PIDAccDiff);
    
    /* prevents from dividing by zero on the first frame, but this method is
        sketchy and should be double-checked */
    if (yDiff == 0 || this.PIDAccDiff == 0) {
      this.yDiff = 1;
      this.PIDAccDiff = 1;
    }
    
    this.pastPIDSum = this.PIDSum;
    this.PIDSum = this.error*this.p - this.yDiff*this.d + this.errorSum*this.i;
  }
  
  public void updateP() {
    this.summationTerm = (this.error *
                (this.yDiff/this.PIDAccDiff) *
                this.error);
    //println(this.error, "^2  * (", this.yDiff, "/", this.PIDAccDiff, ")");
    this.pSum += this.summationTerm;
    //println("Summation:", this.pSum);
    this.partialDerivativeP = (-2/timeStep) * this.pSum;
    //println("Partial Derivative:", this.partialDerivativeP);
    //println();
  }
  
  public void updateI() {
    this.summationTerm = (this.error *
                (this.yDiff/this.PIDAccDiff) *
                this.errorSum);
    this.iSum += this.summationTerm;
    this.partialDerivativeI = (-2/timeStep) * this.iSum;
  }
  
  public void updateD() {
    this.summationTerm = (this.error *
                (this.yDiff/this.PIDAccDiff) *
                this.yDiff);
    this.dSum += this.summationTerm;
    this.partialDerivativeD = (-2/timeStep) * this.dSum;
  }
  
  public void reset() {
    this.PIDSum = 0;
    this.pastPIDSum = 0;
    this.yDiff = 1;
    this.PIDAccDiff = 1;
    
    this.pSum = 0;
    this.iSum = 0;
    this.dSum = 0;
        
    this.partialDerivativeP = 0;
    this.partialDerivativeI = 0;
    this.partialDerivativeD = 0;
  }
  
  public void updateConstants() {
    println("Old Constants", this.p, this.i, this.d);
    this.p += this.pLearningRate * this.partialDerivativeP;
    this.i += this.iLearningRate * this.partialDerivativeI;
    //this.i = 0;
    this.d += this.dLearningRate * this.partialDerivativeD;
    
    println(
            "Partial Derivatives",
            this.partialDerivativeP,
            this.partialDerivativeI,
            this.partialDerivativeD
           );
    println("New Constants", this.p, this.i, this.d);
    println(" ");
    
    this.p = abs(this.p);
    this.i = abs(this.i);
    this.d = abs(this.d);
  }
}
