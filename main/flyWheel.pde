class Flywheel {
  float voltage;
  float torque;
  float angle;
  float angularVelocity;
  float angularAcceleration;
  float current;
  
  float TORQUE_CONSTANT;
  float ANGULAR_VELOCITY_CONSTANT;
  float RESISTANCE;
  float ROTATIONAL_INERTIA;
  float MOTOR_X;
  float MOTOR_Y;
  float CIRCLE_RADIUS;
  float GEAR_RATIO;
  
  //FloatList state;
  
  Flywheel() {
    this.voltage = 2;
    this.torque = 2;
    this.angle = 0;
    this.angularVelocity = 0;
    
    this.TORQUE_CONSTANT = 4.904;
    this.ANGULAR_VELOCITY_CONSTANT = 5.026; 
    this.RESISTANCE = 1.323;
    this.ROTATIONAL_INERTIA = 6.9;
    this.MOTOR_X = 250;
    this.MOTOR_Y = 250;
    this.CIRCLE_RADIUS = 10;
    this.GEAR_RATIO = 1;
    
    this.current = this.voltage/this.RESISTANCE;
    this.angularAcceleration = (this.TORQUE_CONSTANT*(
      this.voltage-(this.angularVelocity/this.ANGULAR_VELOCITY_CONSTANT))) / 
      (this.RESISTANCE * this.current);
    
    //this.state.append(angle);
    //this.state.append(angularVelocity);
  }
  
  //calculates the angular velocity of the motor, given the amount of time passed and
  //the voltage of the motor
  void update(float newVoltage, float timeStep) {
    this.voltage = newVoltage;
    //this.AngularAcceleration = (this.TORQUE_CONSTANT*(
    //  this.voltage-(this.angularVelocity/this.ANGULAR_VELOCITY_CONSTANT))) / 
    //  (this.RESISTANCE * this.current);
    this.angularAcceleration = ((this.GEAR_RATIO * this.TORQUE_CONSTANT) / (this.RESISTANCE * this.ROTATIONAL_INERTIA)) * this.voltage - ((this.GEAR_RATIO * this.GEAR_RATIO * this.TORQUE_CONSTANT)/ (this.ANGULAR_VELOCITY_CONSTANT * this.RESISTANCE * this.ROTATIONAL_INERTIA)) * this.angularVelocity; 
    this.angle = this.angle + this.angularVelocity * timeStep;
    if (this.angle >= 360) {
      this.angle -= 360;
    }
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
    text("Flywheel", MOTOR_X-25, MOTOR_Y-40);
    textSize(10);
    text("Angle: "+round(this.angle), MOTOR_X-25, MOTOR_Y+50);
    text("Velocity: "+round(this.angularVelocity), MOTOR_X-25, MOTOR_Y+65);
  }
}
