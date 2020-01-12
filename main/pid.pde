/* Implements a PID control loop */
class PID {
  float p;
  float i;
  float d;
  float timeStep;
  float error;
  float errorSum;
  
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
    println(current-last);
    println();
    
    return this.error*this.p - (current-last)*this.d + this.errorSum*this.i;
  }
}


//class PIDNeuralNetwork extends PID {
//  float PIDSum;
//  float pastPIDSum;
//  float summationTerm;
//  float yDiff;
//  float PIDAccDiff;
  
//  float pSum;
//  float iSum;
//  float dSum;
  
//  float partialDerivativeP;
//  float partialDerivativeI;
//  float partialDerivativeD;
  
//  float pLearningRate;
//  float iLearningRate;
//  float dLearningRate;
  
//  boolean firstRun;
  
//  PIDNeuralNetwork(float p, float i, float d) {
//    super(p, i, d);
    
//    this.PIDSum = 1;
//    this.pastPIDSum = 0;
//    this.summationTerm = 0;
//    this.yDiff = 1;
//    this.PIDAccDiff = 1;
    
//    this.pSum = 0;
//    this.iSum = 0;
//    this.dSum = 0;
        
//    this.partialDerivativeP = 0;
//    this.partialDerivativeI = 0;
//    this.partialDerivativeD = 0;
    
//    this.pLearningRate = 0.4904 * pow(10,-8);
//    this.iLearningRate = 0.4904 * pow(10,-9);
//    this.dLearningRate = 0.4904 * pow(10,-5);
    
//    this.firstRun = true;
//  }
  
//  /* called every frame */
//  public void sum(float currentY,float pastY) {
//    this.yDiff = currentY-pastY;
//    this.PIDAccDiff = this.PIDSum-this.pastPIDSum;
//    if (yDiff == 0 || this.PIDAccDiff == 0) {
//      this.yDiff = 1;
//      this.PIDAccDiff = 1;
//    }
    
//    this.pastPIDSum = this.PIDSum;
//    this.PIDSum = this.error*this.p - this.yDiff*this.d + this.errorSum*this.i;
//  }
  
//  public void updateYP() {
//    this.summationTerm = (this.error *
//                (this.yDiff/this.PIDAccDiff) *
//                this.error);
//    println(this.error, "^2  * (", this.yDiff, "/", this.PIDAccDiff, ")");
//    this.pSum += this.summationTerm;
//    println("Summation:", this.pSum);
//    this.partialDerivativeP = (-2/time) * this.pSum;
//    println(this.partialDerivativeP);
//    println();
//  }
  
//  public void updateYI() {
//    this.summationTerm = (this.error *
//                (this.yDiff/this.PIDAccDiff) *
//                this.errorSum);
//    this.iSum += this.summationTerm;
//    this.partialDerivativeI = (-2/time) * this.iSum;
//  }
  
//  public void updateYD() {
//    this.summationTerm = (this.error *
//                (this.yDiff/this.PIDAccDiff) *
//                this.yDiff);
//    this.dSum += this.summationTerm;
//    this.partialDerivativeD = (-2/time) * this.dSum;
//  }
  
//  public void reset() {
//    this.PIDSum = 0;
//    this.pastPIDSum = 0;
//    this.yDiff = 1;
//    this.PIDAccDiff = 1;
    
//    this.pSum = 0;
//    this.iSum = 0;
//    this.dSum = 0;
        
//    this.partialDerivativeP = 0;
//    this.partialDerivativeI = 0;
//    this.partialDerivativeD = 0;
    
//    this.firstRun = true;
//  }
  
//  public void updateConstants() {
//    println("Old Constants", this.p, this.i, this.d);
//    this.p += this.pLearningRate * this.partialDerivativeP;
//    this.i += this.iLearningRate * this.partialDerivativeI;
//    this.d += this.dLearningRate * this.partialDerivativeD;
    
//    println(
//            "Partial Derivatives",
//            this.partialDerivativeP,
//            this.partialDerivativeI,
//            this.partialDerivativeD
//           );
//    println("New Constants", this.p, this.i, this.d);
//    println(" ");
    
//    this.p = constrain(abs(this.p), 0, 1);
//    this.i = constrain(abs(this.i), 0, 1);
//    this.d = constrain(abs(this.d), 0, 1);
//  }
//}
