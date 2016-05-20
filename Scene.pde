abstract class Scene {
  PVector anchor;
  PVector size;

  abstract Scene load();
  abstract void  reset();
  abstract void  update();
  abstract void  display();
  abstract void  update_unlock();
  abstract void  display_unlock();

  abstract void  checkHover(float mx, float my);
  abstract void  checkPress(float mx, float my);
  abstract void  checkRelease(float mx, float my);
}

class SceneStart extends Scene {
  float theta;

  SceneStart(int x, int y) {
    anchor = new PVector(x * width, y * height);
    size = new PVector(width, height);
  }

  Scene load() {
    println("Scene Start");
    return this;
  }

  void reset() {
  }

  void update() {
  }

  void display() {
    pushMatrix();
    translate(anchor.x, anchor.y);
    fill(255);
    noStroke();
    rect(0, 0, size.x, size.y);

    theta = map(mouseX, 0, width, 0, PI/2);
    translate(width/2, height * 0.8);
    stroke(0);
    branch(60);
    popMatrix();
  }

  void update_unlock() {
  }

  void display_unlock() {
  }

  void checkHover(float mx, float my) {
  }

  void checkPress(float mx, float my) {
  }

  void checkRelease(float mx, float my) {
  }

  void branch(float len) {
    float sw = map(len, 2, 120, 1, 10);
    strokeWeight(sw);

    line(0, 0, 0, -len);
    translate(0, -len);

    len *= 0.66;
    if (len > 2) {
      pushMatrix();    
      rotate(theta);   
      branch(len);       
      popMatrix(); 

      pushMatrix();
      rotate(-theta);
      branch(len);
      popMatrix();
    }
  }
}

class SceneGame extends Scene {
  SceneGame(int x, int y) {
    anchor = new PVector(x * width, y * height);
    size   = new PVector(width, height);
  }

  Scene load() {
    println("scene game");
    return this;
  }

  void reset() {
  }

  void update() {
  }

  void display() {
    pushMatrix();
    translate(anchor.x, anchor.y);
    fill(#0B091C);
    noStroke();
    rect(0, 0, size.x, size.y);
    popMatrix();
  }

  void update_unlock() {
  }

  void display_unlock() {
  }

  void checkHover(float mx, float my) {
  }

  void checkPress(float mx, float my) {
  }

  void checkRelease(float mx, float my) {
  }
}