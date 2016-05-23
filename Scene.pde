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

    theta = map(mouseY, 0, height, 0, PI/2);
    translate(width/2, height * 0.8);
    stroke(0);
    branch(60);
    popMatrix();

    //noFill();
    //fill(150,100);
    //stroke(50,100);
    //strokeWeight(20);
    //ellipse(200,200,100,100);
    //line(150,200,250,200);
    //stroke(0);
    //strokeWeight(4);
    //ellipse(200,200,124,124);
    //line(200,200,200,160);
    //line(200,200,200,260);
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
  float r, nextR, isLarger;
  float rWeight, RWeight;
  color nextC;
  final int die = 0;
  final int running = 1;
  final int stop = 2;
  int gameState;

  SceneGame(int x, int y) {
    anchor = new PVector(x * width, y * height);
    size   = new PVector(width, height);

    rWeight = 4;
    RWeight = 20;
    r = 0;
    nextR = random(100, 400);
    isLarger = r - nextR;
    nextC = color(random(255), random(255), random(255));

    gameState = running;
  }

  Scene load() {
    println("scene game");
    return this;
  }

  void reset() {
  }

  void update() {
    if (gameState == running) {
      if (isLarger >= 0) {
        r -= 2;
      } else {
        r += 2;
      }
    }

    if (((isLarger >= 0) && (r + rWeight/2) <= (nextR - RWeight/2)) || 
     ((isLarger < 0) && (r - rWeight/2) >= (nextR + RWeight/2))) {
     gameState = die;
    }

    if (gameState == die)
    {
      if (isLarger  >= 0) {
        println(r + rWeight/2);
        println(nextR - RWeight/2 + "---");
      } else {
        println(r - rWeight/2);
        println(nextR + RWeight/2 + "---");
      }
    }
  }

  void display() {
    pushMatrix();
    translate(anchor.x, anchor.y);
    fill(#0B091C);
    noStroke();
    rect(0, 0, size.x, size.y);

    noFill();

    //next circle
    stroke(nextC);
    strokeWeight(RWeight);
    ellipse(width/2, height/2, nextR, nextR);
    strokeWeight(0);
    stroke(255);
    line(width/2, height/2, width/2 - nextR/2 - RWeight/2, height/2);

    //the circle
    stroke(100);
    strokeWeight(rWeight);
    ellipse(width/2, height/2, r, r);
    strokeWeight(0);
    stroke(255);
    line(width/2, height/2, width/2, height/2 + r/2 - rWeight/2);
    popMatrix();
  }

  void update_unlock() {
  }

  void display_unlock() {
  }

  void checkHover(float mx, float my) {
  }

  void checkPress(float mx, float my) {
    //change
    if ((r + rWeight/2) <= (nextR + RWeight/2) &&
      (r - rWeight/2) >= (nextR - RWeight/2)) {
      nextR = random(100, 200);
      nextC = color(random(255), random(255), random(255));
      isLarger = r - nextR;
    } else
    {
      //gameState = die;
    }
  }

  void checkRelease(float mx, float my) {
  }
}