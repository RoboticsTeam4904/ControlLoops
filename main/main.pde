Flywheel fly = new Flywheel();
float timeStep = 0.1;

PID pid = new PID(5, 0.5, 0, timeStep);

float targetVelocity = 30;

Grapher g = new Grapher(targetVelocity);

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
  g.display();
}
