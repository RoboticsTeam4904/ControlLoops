// a motor that uses state space to keep track of position and simulate movement
// SCALE: 10 pixels = 1 unit of measurement eg. the radius of the original motor
// TODO: find out why linear velocity isn't proportional to roller radius

class Motor {
  float voltage;
  float torque;
  float angle;
  float angularVelocity;
  float changeAngularVelocity;
  float current;
  
  float TORQUE_CONSTANT;
  float ANGULAR_VELOCITY_CONSTANT;
  float RESISTANCE;
  float ROTATIONAL_INERTIA;
  float MOTOR_X;
  float MOTOR_Y;
  float CIRCLE_RADIUS;
  
  FloatList state;
  
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
    this.CIRCLE_RADIUS = 10;
    
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
    ellipse(this.MOTOR_X, this.MOTOR_Y, this.CIRCLE_RADIUS*2, this.CIRCLE_RADIUS*2);
    
    //draws the indicator for the motor rotation
    fill(255, 0, 0);
    //sine is negative because Processing y coordinates increase downwards
    ellipse(this.CIRCLE_RADIUS*cos(radians(testMotor.angle))+MOTOR_X,
            this.CIRCLE_RADIUS*-sin(radians(testMotor.angle))+MOTOR_Y,
            10,
            10);
    
    fill(0, 0, 0);
    textSize(15);
    text("Motor", MOTOR_X-25, MOTOR_Y-40);
    textSize(10);
    text("Angle: "+round(this.angle), MOTOR_X-25, MOTOR_Y+50);
    text("Velocity: "+round(this.angularVelocity), MOTOR_X-25, MOTOR_Y+65);
  }
}

// a gearbox that alters the angular velocity of a motor using gears of varying sizes
class Gearbox {
  Motor motor;
  float GEAR_RATIO;
  float GEARBOX_X;
  float GEARBOX_Y;
  
  Gearbox(Motor motor) {
    this.motor = motor;
    this.GEAR_RATIO = 0.4904;
    this.GEARBOX_X = 250;
    this.GEARBOX_Y = 250;
  }
  
  float newAngularVelocity() {
    return(this.motor.angularVelocity * this.GEAR_RATIO);
  }
  
  void display() {
    //draws gearbox, fully embracing the "box" part
    fill(0, 0, 0);
    rect(this.GEARBOX_X-15, this.GEARBOX_X-15, 30, 30);
    
    textSize(15);
    text("Gearbox", GEARBOX_X-30, GEARBOX_Y-40);
    textSize(10);
    text("Ratio: "+this.GEAR_RATIO, this.GEARBOX_X-25, this.GEARBOX_Y+50);
    text("Velocity: "+round(this.newAngularVelocity()), this.GEARBOX_X-25, this.GEARBOX_Y+65);
  }
}

// class for the final roller/gear in the gearbox and the elevator system, which
// converts angular velocity into linear velocity
class RollerElevator {
  Gearbox gearbox;
  float ROLLER_RADIUS;
  float ROLLER_X;
  float ROLLER_Y;
  float angle;
  float angularVelocity;
  float elevatorY;
  float linearVelocity;
  
  RollerElevator(Gearbox gearbox) {
    this.gearbox = gearbox;
    this.ROLLER_RADIUS = 50;
    this.ROLLER_X = 350;
    this.ROLLER_Y = 250;
    this.angularVelocity = this.gearbox.newAngularVelocity();
    this.angle = 0;
    this.linearVelocity = 0;
    this.elevatorY = 250;
  }
  
  void update(float timeStep) {
    this.angularVelocity = this.gearbox.newAngularVelocity();
    this.linearVelocity = this.ROLLER_RADIUS*TWO_PI*(this.angularVelocity/360);
    
    this.angle = this.angle + this.angularVelocity * timeStep;
    if (this.angle >= 360) {
      this.angle -= 360;
    }
    
    //for the elevator, signs are reversed because Y increases downwards
    this.elevatorY = this.elevatorY - this.linearVelocity * timeStep;
    
    // assumption: the elevator can be raised to maximum height with exactly
    // one full revolution of the roller
    if (this.elevatorY <= (250-this.ROLLER_RADIUS*TWO_PI)) {
      this.elevatorY += this.ROLLER_RADIUS*TWO_PI;
    }
  }
  
  void display() {  
    //draws the motor
    fill(255, 255, 255);
    ellipse(this.ROLLER_X, this.ROLLER_Y, this.ROLLER_RADIUS*2, this.ROLLER_RADIUS*2);
    
    //draws the indicator for the motor rotation
    fill(0, 255, 0);
    //sine is negative because Processing y coordinates increase downwards
    ellipse(this.ROLLER_RADIUS*cos(radians(this.angle))+this.ROLLER_X,
            this.ROLLER_RADIUS*-sin(radians(this.angle))+this.ROLLER_Y,
            10,
            10);
    
    fill(0, 0, 0);
    textSize(15);
    text("Elevator/Roller", this.ROLLER_X-45, this.ROLLER_Y-40);
    textSize(10);
    text("Angle: "+round(this.angle), this.ROLLER_X-25, this.ROLLER_Y+50);
    text("Ang. Velocity: "+round(this.angularVelocity), this.ROLLER_X-25, this.ROLLER_Y+65);
    text("Lin. Velocity: "+round(this.angularVelocity), this.ROLLER_X-25, this.ROLLER_Y+80);
    
    //draws the elevator
    fill(0, 0, 255);
    rect(420, this.elevatorY, 20, 20);
  }
}

Motor testMotor = new Motor();
Gearbox testGearbox = new Gearbox(testMotor);
RollerElevator testElevator = new RollerElevator(testGearbox);
float timeStep = 0.2;

void setup() {
  size(500,500);
  background(255);
}

void draw() {
  background(255,255,255);
  testMotor.update(3, timeStep);
  testMotor.display();
  testGearbox.display();
  testElevator.update(timeStep);
  testElevator.display();
}

//this.voltage = (this.torque/this.TORQUE_CONSTANT)*this.RESISTANCE +
//  this.angularVelocity/this.ANGULAR_VELOCITY_CONSTANT;
