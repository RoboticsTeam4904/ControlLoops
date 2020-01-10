Flywheel fly = new Flywheel();
float timeStep = 0.1;

PID pid = new PID(1, 0, 0);

float targetVelocity = 30;

float lastV = fly.angularVelocity;

void setup() {
  size(500,500);
  background(255);
}

void draw() {
  background(255,255,255);
  fly.update(pid.update(fly.angularVelocity, lastV, targetVelocity), timeStep);
  lastV = fly.angularVelocity;
  fly.display();
}
