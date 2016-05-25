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
  abstract void  checkKeyPress(float mx, float my);
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

  void  checkKeyPress(float mx, float my) {
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
  Audio au;
  ArrayList<Circle> cs;
  ArrayList<ParticleSystem> pss;
  ArrayList<TextArea> tas;
  int timer, maxTime;
  int lastCreatPosX, lastCreatPosY;
  PImage bg;
  int id,clickCount;
  int difficulty;

  SceneGame(int x, int y) {
    anchor = new PVector(x * width, y * height);
    size   = new PVector(width, height);

    init();
  }

  void init() {
    au = new Audio();
    cs = new ArrayList<Circle>();
    pss = new ArrayList<ParticleSystem>();
    tas = new ArrayList<TextArea>();

    lastCreatPosX = width/2;
    lastCreatPosY = height/2;

    bg = loadImage("bg.jpg");

    maxTime = 1000;
    timer = millis();
     
    id = 0;
    difficulty = 2;
  }

  Scene load() {
    println("scene game");
    return this;
  }

  void reset() {
    println("reset");
    init();
  }

  void update() {
    if (millis() - timer >= maxTime)
      au.song.play();

    if (au.canCreat(difficulty)) {
      cs.add(new Circle(lastCreatPosX, lastCreatPosY,++id));
      float ranx = random(100);
      float rany = random(100);
      if(ranx < 50)
        lastCreatPosX += random(-120,-100);
      else
        lastCreatPosX += random(100,120);
      if(rany < 50)
        lastCreatPosY += random(-120,-100);
      else
        lastCreatPosY += random(100,120);
      lastCreatPosX = constrain(lastCreatPosX,100,width - 100);
      lastCreatPosY = constrain(lastCreatPosY,100,height - 100);
    }
  }

  void display() {
    pushMatrix();
    //bg
    translate(anchor.x, anchor.y);
    image(bg, 0, 0, width, height);
    //audio
    au.display();
    //circle
    for (int i = cs.size() - 1; i >= 0; i--) {
      Circle c = cs.get(i);
      if (c.circleState == 2) {
        //pss.add(new ParticleSystem(c.x, c.y, int(c.R + 10), int(random(80, 120)), c.col));
        cs.remove(i);
      } else
        c.run();
    }
    //particle systems
    for (int i = pss.size() - 1; i >= 0; i--) {
      ParticleSystem p = pss.get(i);
      if (p.dead()) 
        pss.remove(i);
      else
        p.run();
    }
    //text
    for (int i = 0; i < tas.size(); i++) {
      if (tas.get(i).isDead())
        tas.remove(tas.get(i));
      else
        tas.get(i).draw();
    }
    popMatrix();
  }

  void update_unlock() {
  }

  void display_unlock() {
  }

  void checkHover(float mx, float my) {
  }

  void checkPress(float mx, float my) {
    for (int i = cs.size() - 1; i >= 0; i--) {
      Circle c = cs.get(i);
      if (c.isInside(mx, my) && c.circleState == 1 ){//&& (++clickCount == c.id)) {
        String str = null;
        if ((c.r - c.R) <= 0.5)
          str = "Perfect";
        else if ((c.r - c.R) <= 1)
          str = "Nice";
        else
          str = "Good";
        tas.add(new TextArea(mx - width - 100, my - 100, 100, 100, str));
        pss.add(new ParticleSystem(c.x, c.y, int(c.R + 10), int(random(80, 120)), c.col));
        c.circleState = 2;
      }
    }
  }

  void checkRelease(float mx, float my) {
  }

  void checkKeyPress(float mx, float my) {
    if(keyCode == 49)
      difficulty = 1;
    else if(keyCode == 50)
      difficulty = 2;
    else if(keyCode == 51)
      difficulty = 3;
    else if(keyCode == 52)
      difficulty = 4;
    println(difficulty);
    
    for (int i = cs.size() - 1; i >= 0; i--) {
      Circle c = cs.get(i);
      if (c.isInside(mx, my) && c.circleState == 1 ){//&& (clickCount == c.id)) {
        String str = null;
        if ((c.r - c.R) <= 0.5)
          str = "Perfect";
        else if ((c.r - c.R) <= 1)
          str = "Nice";
        else
          str = "Good";
        tas.add(new TextArea(mx - width - 100, my - 100, 100, 100, str));
        pss.add(new ParticleSystem(c.x, c.y, int(c.R + 10), int(random(80, 120)), c.col));
        c.circleState = 2;
      }
    }
  }
}