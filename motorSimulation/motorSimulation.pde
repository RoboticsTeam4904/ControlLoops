//physics

class Motor {
  public float voltage;
  public float torque;
  public float angularVelocity;
  
  public float TORQUE_CONSTANT;
  public float VOLTAGE_CONSTANT;
  public float RESISTANCE;
  public float ROTATIONAL_INERTIA;
  
  Motor() {
    this.voltage = 0;
    
    this.TORQUE_CONSTANT = 4.5;
    this.VOLTAGE_CONSTANT = 5.6;
    this.RESISTANCE = 1.3;
    this.ROTATIONAL_INERTIA = 7;
  }
  
}


void setup() {
  size(500,500);
  background(255);
}

void draw() {
  background(255,255,255);
  textSize(50);
  fill(0, 0, 0);
  text(":)", 200, 200);
}
