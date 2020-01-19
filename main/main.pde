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

boolean messedWith = false;

float threshold = 0.05;

//PID pid = new PID(1, 0, 3, timeStep);

PIDAutoTuner pid = new PIDAutoTuner(6.10, 0, 55.65, timeStep);

float targetDistance = 4;

float startTargetVelocity = DistanceCalculator.getVelocity(targetDistance);

float targetVelocity = startTargetVelocity;

boolean usedGraph = false;

Grapher g = new Grapher(targetVelocity);

TimingGrapher timingGraph = new TimingGrapher();

void setup() {
  
  println(targetVelocity);
  
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
  
  pid.sum(fly.angularVelocity, fly.lastAV);
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
  text("Time:" + bestTime, 350, 310);
      
  if(abs(targetVelocity-fly.angularVelocity)<threshold) {
     framesOnTarget +=1;
   }
   else{
     framesOnTarget =0;
   }
  
  if (framesOnTarget > 50){
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
    
    //pid.i = 0;
    if(!messedWith) {
      pid.updateConstants();
      //pid.i = 0;
      timingGraph.addPoint(timeFromStart);
      float[] vals = {pid.p, pid.i, pid.d };
      pid.pastVals.add(vals);
    }
    reset();
      
  }
  if (mousePressed == true) {
    if(mouseY < g.yPos && mouseY > g.yPos - 100 && mouseX > g.xPos && mouseX < g.xPos + 400) {
      targetVelocity = g.yPos - mouseY;
      g.target = targetVelocity;
      messedWith = true;
    }
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
    
    pid.PIDSum = 1;
    pid.pastPIDSum = 0;
    pid.summationTerm = 0;
    pid.yDiff = 1;
    pid.PIDAccDiff = 1;
    
    pid.pSum = 0;
    pid.iSum = 0;
    pid.dSum = 0;
        
    pid.partialDerivativeP = 0;
    pid.partialDerivativeI = 0;
    pid.partialDerivativeD = 0;
    
    targetVelocity = startTargetVelocity;
    g.target = targetVelocity;
    
    if(!usedGraph) {
      messedWith = false;
    }
}

void mouseClicked() {
  
  if(mouseY < timingGraph.yPos && mouseY > timingGraph.yPos - 100 && mouseX > timingGraph.xPos && mouseX < timingGraph.xPos + 400) {
    int x = (int) ((mouseX - timingGraph.xPos) / timingGraph.scale);
    print(x);
    reset();
    float[] vals = pid.pastVals.get(x);
    pid.p = vals[0];
    pid.i = vals[1];
    pid.d = vals[2];
    usedGraph = true;
    messedWith = true;
  }
}
