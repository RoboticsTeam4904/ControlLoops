// a motor that uses state space to keep track of position and simulate movement
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
  public float MOTOR_X;
  public float MOTOR_Y;
  
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
    this.MOTOR_X = 150;
    this.MOTOR_Y = 250;
    
    this.current = this.voltage/this.RESISTANCE;
    this.changeAngularVelocity = (this.TORQUE_CONSTANT*(
      this.voltage-(this.angularVelocity/this.ANGULAR_VELOCITY_CONSTANT))) / 
      (this.RESISTANCE * this.current);
    
    //this.state.append(angle);
    //this.state.append(angularVelocity);
  }
  
  //calculates the angular velocity of the motor, given the amount of time passed and
  //the voltage of the motor
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
  
  void display() {  
    //draws the motor
    fill(255, 255, 255);
    ellipse(MOTOR_X, MOTOR_Y, RADIUS*2, RADIUS*2);
    
    //draws the indicator for the motor rotation
    fill(255, 0, 0);
    //sine is negative because Processing y coordinates increase downwards
    ellipse(RADIUS*cos(radians(testMotor.angle))+MOTOR_X,
            RADIUS*-sin(radians(testMotor.angle))+MOTOR_Y,
            10,
            10);
    
    fill(0, 0, 0);
    textSize(10);
    text("Angle: "+round(this.angle), MOTOR_X-25, MOTOR_Y+50);
    text("Velocity: "+round(this.angularVelocity), MOTOR_X-25, MOTOR_Y+65);
    
  }
}

// a gearbox that alters the angular velocity of a motor
class Gearbox {
  public Motor motor;
  public float GEAR_RATIO;
  public float GEARBOX_X;
  public float GEARBOX_Y;
  
  Gearbox(Motor motor) {
    this.motor = motor;
    this.GEAR_RATIO = 2.54;
    this.GEARBOX_X = 250;
    this.GEARBOX_Y = 250;
  }
  
  float newAngularVelocity() {
    return(this.motor.angularVelocity * this.GEAR_RATIO);
  }
  
  void display() {
    fill(0, 0, 0);
    rect(this.GEARBOX_X-15, this.GEARBOX_X-15, 30, 30);
    text("Ratio: "+this.GEAR_RATIO, this.GEARBOX_X-25, this.GEARBOX_Y+50);
    text("Velocity: "+round(this.newAngularVelocity()), this.GEARBOX_X-25, this.GEARBOX_Y+65);
  }
}

Motor testMotor = new Motor();
Gearbox testGearbox = new Gearbox(testMotor);
float timeStep = 0.2;
float RADIUS = 20;

void setup() {
  size(500,500);
  background(255);
}

void draw() {
  background(255,255,255);
  testMotor.update(3, timeStep);
  testMotor.display();
  testGearbox.display();
}

//this.voltage = (this.torque/this.TORQUE_CONSTANT)*this.RESISTANCE +
//  this.angularVelocity/this.ANGULAR_VELOCITY_CONSTANT;
