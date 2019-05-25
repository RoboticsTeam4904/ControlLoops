//physics

class Motor {
  public float voltage;
  public float torque;
  public float angle;
  public float angularVelocity;
  public float changeAngularVelocity;
  public float current;
  
  public float TORQUE_CONSTANT;
  public float ANGULAR_VELOCITY_CONSTANT;
  public float RESISTANCE;
  public float ROTATIONAL_INERTIA;
  
  public FloatList state;
  
  Motor() {
    this.voltage = 2;
    this.torque = 2;
    this.angle = 0;
    this.angularVelocity = 0;
        
    this.TORQUE_CONSTANT = 4.904;
    this.ANGULAR_VELOCITY_CONSTANT = 5.026; 
    this.RESISTANCE = 1.323;
    this.ROTATIONAL_INERTIA = 6.9;
    
    this.current = this.voltage/this.RESISTANCE;
    this.changeAngularVelocity = (this.TORQUE_CONSTANT*(
      this.voltage-(this.angularVelocity/this.ANGULAR_VELOCITY_CONSTANT))) / 
      (this.RESISTANCE * this.current);
    
    //this.state.append(angle);
    //this.state.append(angularVelocity);
  }
  
  void update(float newVoltage, float timeStep) {
    this.voltage = newVoltage;
    this.changeAngularVelocity = (this.TORQUE_CONSTANT*(
      this.voltage-(this.angularVelocity/this.ANGULAR_VELOCITY_CONSTANT))) / 
      (this.RESISTANCE * this.current);
    this.angle = this.angle + this.angularVelocity * timeStep;
    if (this.angle >= 360) {
      this.angle -= 360;
    }
    this.angularVelocity = this.angularVelocity + this.changeAngularVelocity * timeStep;
  }
  //karen was here
  void display() {
    println("Angle: " + this.angle);
    println("Angular velocity: " + this.angularVelocity);
  }
}

Motor testMotor = new Motor();
float timeStep = 0.2;

void setup() {
  size(500,500);
  background(255);
}

void draw() {
  background(255,255,255);
  textSize(50);
  fill(0, 0, 0);
  text(":)", 200, 200);
  testMotor.update(3, timeStep);
  testMotor.display();
}

//this.voltage = (this.torque/this.TORQUE_CONSTANT)*this.RESISTANCE +
//  this.angularVelocity/this.ANGULAR_VELOCITY_CONSTANT;
