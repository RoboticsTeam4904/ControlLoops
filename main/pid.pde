/* Implements a PID control loop */
class PID {
  float p;
  float i;
  float d;
  float error;
  float errorSum;
  
PID(float p, float i, float d) {
    this.p = p;
    this.i = i;
    this.d = d;
    this.errorSum = 0;
  }
 
  public float update(float current, float past, float target) {
    this.error = target-current;
    this.errorSum += this.error;
    return this.error*this.p - (current-past)*this.d + this.errorSum*this.i;
  }
}
