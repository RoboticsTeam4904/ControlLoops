Flywheel fly = new Flywheel();
float timeStep = 0.01666666667;

boolean alreadySetFinished= false;
float timeFromStart= millis()/1000;
float framesOnTarget=0;

float startTime = 0;

float bestTime = 50;
float bestP = 0;
float bestI = 0;
float bestD = 0;

float threshold = 0.05;

//PID pid = new PID(1, 0, 3, timeStep);

PIDAutoTuner pid = new PIDAutoTuner(1, 0, 5, timeStep);

float targetVelocity = 50;

Grapher g = new Grapher(targetVelocity);

TimingGrapher timingGraph = new TimingGrapher();

void setup() {
  
  timingGraph.yPos = 150;
  g.yPos = 450;
  
  size(500,500);
  frameRate(60);
}

void draw() {
  background(245);
  float pidOut = pid.update(fly.angularVelocity, fly.lastAV, targetVelocity);
  fly.update(pidOut, timeStep);
  fly.display();
  g.addPoint(fly.angularVelocity);
  g.display();
  timingGraph.display();
  
  pid.updateP();
  pid.updateI();
  pid.updateD();
  
  textSize(12);
  text("Current Constants", 50, 230);
  text("P: " + pid.p, 50, 250);
  text("I: " + pid.i, 50, 270);
  text("D: " + pid.d, 50, 290);
  
  textSize(12);
  text("Best Constants", 350, 230);
  text("P: " + bestP, 350, 250);
  text("I: " + bestI, 350, 270);
  text("D: " + bestD, 350, 290);
      
  if(abs(targetVelocity-fly.angularVelocity)<threshold) {
     framesOnTarget +=1;
   }
   else{
     framesOnTarget =0;
   }
  
  if (framesOnTarget > 20){
    if(! alreadySetFinished){
      timeFromStart= (millis() - startTime)/1000.0;
      alreadySetFinished=true;
    }
  text("Finished in : "+ timeFromStart, 50, 50 );
}
  if(framesOnTarget > 100) {
    if(timeFromStart < bestTime) {
        bestTime = timeFromStart;
        bestP = pid.p;
        bestI = pid.i;
        bestD = pid.d;
    }
    pid.updateConstants();
    pid.i = 0;
    timingGraph.addPoint(timeFromStart);
    reset();
      
  }
}

void reset() {
      fly.angularVelocity = 0;
      fly.lastAV = 0;
      pid.errorSum = 0;
      alreadySetFinished = false;
      framesOnTarget = 0;
      g.points.clear();
      g.scale = g.startScale;
      startTime = millis();
}
