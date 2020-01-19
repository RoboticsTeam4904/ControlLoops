static class DistanceCalculator {
  
  static final float goalHeight = 2.49555;
  static final float shooterHeight = 1.0668;
  
  static final float g = 9.8;
  
  static float shooterAngle = 0.52;
  
  public static float getVelocity(float dist) {
    
    float v = (sqrt(g) * dist * (1.0 / (float) Math.cos(shooterAngle))) / (sqrt(2) * sqrt(shooterHeight + dist * tan(shooterAngle) - goalHeight));
    println(shooterHeight + dist * tan(shooterAngle));
    println(shooterHeight + dist * tan(shooterAngle) - goalHeight);
    return v;
  }
}
