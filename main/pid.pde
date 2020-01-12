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
    println(this.error*this.p);
    println(this.error*this.p - (current-last)*this.d + this.errorSum*this.i);
    println();
    
    return this.error*this.p - (current-last)*this.d + this.errorSum*this.i;
  }
}
