class Particle {
  PVector loc;
  float lifespan;
  int R;
  color col;
  float r,cx,cy;

  Particle(color mCol, int mR) {
    col = mCol;
    R = mR;
    lifespan = 255.0;
    r = random(3, 20);
    cx = 0;
    cy = 0;
    
    float ran = random(100);
    float temX = random(width/2 - mR,width/2 + mR);
    float temY = sqrt(pow(R,2) - pow(abs(width/2 - temX),2));
    if(ran < 50){
      loc = new PVector(temX,height/2 - temY);
    }
    else
      loc = new PVector(temX,height/2 + temY);
  }
  
  Particle(float x,float y,color mCol, int mR) {
    col = mCol;
    R = mR;
    lifespan = 255.0;
    r = random(3, 20);
    cx = x;
    cy = y;
    
    float ran = random(100);
    float temX = random(cx - mR,cx + mR);
    float temY = sqrt(pow(R,2) - pow(abs(cx - temX),2));
    if(ran < 50){
      loc = new PVector(temX,cy - temY);
    }
    else
      loc = new PVector(temX,cy + temY);
  }
  
  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    PVector f = new PVector(width/2,height/2).sub(loc);
    loc.add(f.normalize().mult(-0.8));
    if(r > 3)
      r -= 0.2;
    lifespan -= 10.0;
  }

  // Method to display
  void display() {
    fill(col, lifespan);
    noStroke();
    ellipse(loc.x, loc.y, r, r);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}