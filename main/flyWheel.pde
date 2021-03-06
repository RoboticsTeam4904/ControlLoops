class Flywheel {
  float voltage;
  float torque;
  float angle;
  float angularVelocity;
  float angularAcceleration;
  float current;
  
  float STALL_VOLTAGE;
  float TORQUE_CONSTANT;
  float ANGULAR_VELOCITY_CONSTANT;
  float RESISTANCE;
  float ROTATIONAL_INERTIA;
  float MOTOR_X;
  float MOTOR_Y;
  float CIRCLE_RADIUS;
  float GEAR_RATIO;
  float lastAV;
  
  float STALL_TORQUE;
  float STALL_CURRENT;
  float FREE_SPEED;
  //FloatList state;
  
  Flywheel() {
    this.STALL_VOLTAGE = 12;
    this.torque = 2;
    this.angle = 0;
    this.angularVelocity = 0;
    //this.ANGULAR_VELOCITY_CONSTANT = ((this.GEAR_RATIO*this.TORQUE_CONSTANT)/(this.RESISTANCE*this.ROTATIONAL_INERTIA));
    
    this.STALL_TORQUE = 4.69;
    this.STALL_CURRENT = 257;
    this.FREE_SPEED = 38280;
    
    this.TORQUE_CONSTANT = this.STALL_TORQUE/this.STALL_CURRENT;
    this.ANGULAR_VELOCITY_CONSTANT = this.FREE_SPEED/(this.STALL_VOLTAGE-this.current*this.RESISTANCE); 
    this.RESISTANCE = this.STALL_VOLTAGE/this.STALL_CURRENT;
    this.ROTATIONAL_INERTIA = 1;
    this.MOTOR_X = 250;
    this.MOTOR_Y = 250;
    this.CIRCLE_RADIUS = 10;
    this.GEAR_RATIO = 1;
    this.lastAV = 0;
    
    this.current = this.STALL_VOLTAGE/this.RESISTANCE;
    this.angularAcceleration = (this.TORQUE_CONSTANT*(
      this.STALL_VOLTAGE-(this.angularVelocity/this.ANGULAR_VELOCITY_CONSTANT))) / 
      (this.RESISTANCE * this.current);
    
    //this.state.append(angle);
    //this.state.append(angularVelocity);
  }
  
  //calculates the angular velocity of the motor, given the amount of time passed and
  //the voltage of the motor
  void update(float newVoltage, float timeStep) {

    this.voltage += newVoltage;
    //this.AngularAcceleration = (this.TORQUE_CONSTANT*(
    //  this.voltage-(this.angularVelocity/this.ANGULAR_VELOCITY_CONSTANT))) / 
    //  (this.RESISTANCE * this.current);
    this.angularAcceleration = ((this.GEAR_RATIO * this.TORQUE_CONSTANT) / (this.RESISTANCE * this.ROTATIONAL_INERTIA)) * this.voltage - ((this.GEAR_RATIO * this.GEAR_RATIO * this.TORQUE_CONSTANT)/ (this.ANGULAR_VELOCITY_CONSTANT * this.RESISTANCE * this.ROTATIONAL_INERTIA)) * this.angularVelocity; 
    this.angle -= this.angularVelocity * timeStep * 10;
    if (this.angle >= 360) {
      this.angle -= 360;
    }
    this.lastAV = this.angularVelocity;
    this.angularVelocity = this.angularVelocity + this.angularAcceleration * timeStep;
  }
  
  void display() {  
    //draws the motor
    fill(255, 255, 255);
    ellipse(this.MOTOR_X, this.MOTOR_Y, this.CIRCLE_RADIUS*2, this.CIRCLE_RADIUS*2);
    
    //draws the indicator for the motor rotation
    fill(255, 0, 0);
    //sine is negative because Processing y coordinates increase downwards
    ellipse(this.CIRCLE_RADIUS*cos(radians(this.angle))+MOTOR_X,
            this.CIRCLE_RADIUS*-sin(radians(this.angle))+MOTOR_Y,
            10,
            10);
    
    fill(0, 0, 0);
    textSize(15);
    text("Flywheel", MOTOR_X-25, 30);
    textSize(10);
    text("Velocity: "+this.angularVelocity, MOTOR_X-40, MOTOR_Y+65);
  }
}
