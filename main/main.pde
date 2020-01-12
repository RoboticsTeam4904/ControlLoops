Flywheel fly = new Flywheel();
float timeStep = 0.1;

PID pid = new PID(0.1, 0, 1, timeStep);

float targetVelocity = 50;

Grapher g = new Grapher(targetVelocity);

void setup() {
  size(500,500);
  background(255);
}

void draw() {
  background(255,255,255);
  float pidOut = pid.update(fly.angularVelocity, fly.lastAV, targetVelocity);
  fly.update(pidOut, timeStep);
  fly.display();
  g.addPoint(fly.angularVelocity);
  g.display();
}
