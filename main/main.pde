Flywheel fly = new Flywheel();
float timeStep = 0.1;

boolean alreadySetFinished= false;
float timeFromStart= millis()/1000;
float framesOnTarget=0;

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
      
  if(abs(targetVelocity-fly.angularVelocity)<0.01) {
     framesOnTarget +=1;
   }
   else{
     framesOnTarget =0;
   }
  
  if (framesOnTarget > 15){
    println(fly.angularVelocity);
    if(! alreadySetFinished){
      timeFromStart= millis()/1000;
      alreadySetFinished=true;
    }
  text("Finished in : "+ timeFromStart, 50, 50 );
}
}
