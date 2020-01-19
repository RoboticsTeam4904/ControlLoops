float timeStep = 0.01666666667;

Flywheel fly = new Flywheel();
PID pid = new PID(1, 0, 1, timeStep);

float targetX = 40;
float targetY = 40;

void setup() {
    size(500,500);
    background(255);
}

void draw() {
  strokeWeight(2);
  fill(0, 200, 0);
  circle(targetX, targetY, 20);
}
