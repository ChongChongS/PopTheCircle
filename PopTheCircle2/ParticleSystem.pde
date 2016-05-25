class ParticleSystem {

  ArrayList<Particle> particles;
  int R;
  float locX,locY;

  ParticleSystem(float cx,float cy,int R, int num, color col) {
    locX = cx;
    locY = cy;
    
    particles = new ArrayList<Particle>();        
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(cx,cy,col, R));
    }
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      if (p.isDead()) 
        particles.remove(i);
      else
        p.run();
    }
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }
  
}