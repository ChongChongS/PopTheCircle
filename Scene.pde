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
  abstract void  checkKeyPress();
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

  void  checkKeyPress() {
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
  //圆
  float r, nextR, isLarger;
  float rWeight, RWeight;
  color nextC;
  float speed;
  public boolean isCircle;
  //游戏状态
  final int die = 0;
  final int running = 1;
  final int stop = 2; 
  int gameState;
  //关于粒子
  ArrayList<ParticleSystem> particleSystems;
  //每回合的暂停
  int timer, maxTime;
  //游戏音效
  ArrayList<AudioPlayer> sounds;
  //显示文字与图片
  ArrayList<TextArea> tas;
  int score;
  PImage bg;

  SceneGame(int x, int y) {
    anchor = new PVector(x * width, y * height);
    size   = new PVector(width, height);

    init();
  }

  void init() {
    rWeight = 4;
    RWeight = 20;
    r = 20;
    nextR = random(100, 200);
    isLarger = r - nextR;
    nextC = color(random(255), random(255), random(255));
    speed = 2;
    isCircle = true;

    gameState = running;

    particleSystems = new ArrayList<ParticleSystem>();

    maxTime = 800;
    timer = millis();

    sounds = new ArrayList<AudioPlayer>();
    sounds.add(minim.loadFile("sound1.mp3"));
    sounds.add(minim.loadFile("sound2.mp3"));
    sounds.add(minim.loadFile("sound3.mp3"));
    sounds.add(minim.loadFile("sound4.mp3"));
    sounds.add(minim.loadFile("sound5.mp3"));
    sounds.add(minim.loadFile("sound6.mp3"));
    sounds.add(minim.loadFile("sound7.mp3"));

    tas = new ArrayList<TextArea>();
    score = 0;
    bg = loadImage("bg.jpg");
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
    if (millis() - timer >= maxTime) {
      if (gameState == running) {

        //缩放圆圈  
        if (isLarger >= 0) {
          r -= speed;
        } else {
          r += speed;
        }
      }

      if (((isLarger >= 0) && (r + rWeight/2) <= (nextR - RWeight)) || 
        ((isLarger < 0) && (r - rWeight/2) >= (nextR + RWeight))) {
        gameState = die;
        sounds.get(0).rewind();
        sounds.get(0).pause();
      }

      if (gameState == die)
      {
        if (r <= height)
          Ani.to(this, 0.2, "r", height * 2, Ani.BOUNCE_IN_OUT);
        sounds.get(0).pause();
      }
    }
  }

  void display() {
    pushMatrix();
    translate(anchor.x, anchor.y);
    fill(#f2eada);
    noStroke();
    rect(0, 0, size.x, size.y);
    fill(0);
    textSize(15);
    text("space to change shape", width * 0.15, height * 0.3);
    text("1 speed down,2 speed up", width * 0.15, height * 0.4);
    text("speed: " + speed, width * 0.1, height * 0.5);
    text("score: " + score, width * 0.1, height * 0.6);
    //image(bg, 0, 0, width, height);

    if (r <= height) {
      noFill();

      //next circle
      stroke(nextC);
      strokeWeight(RWeight);
      if (isCircle)
        ellipse(width/2, height/2, nextR, nextR);
      else
        rect(width/2 - nextR/2, height/2 - nextR/2, nextR, nextR);
      strokeWeight(0);
      stroke(255);
      //line(width/2, height/2, width/2 - nextR/2 - RWeight/2, height/2);

      //the circle
      stroke(100);
      strokeWeight(rWeight);
      if (isCircle)
        ellipse(width/2, height/2, r, r);
      else
        rect(width/2 - r/2, height/2 - r/2, r, r);
      strokeWeight(0);
      stroke(255);
      //line(width/2, height/2, width/2, height/2 + r/2 - rWeight/2);

      //particles
      if (particleSystems.size() > 0)
      {
        for (int i = 0; i < particleSystems.size(); i++) {
          if (particleSystems.get(i).dead())
            particleSystems.remove(particleSystems.get(i));
          else
            particleSystems.get(i).run();
        }
      }

      //texts
      if (tas.size() > 0) {
        for (int i = 0; i < tas.size(); i++) {
          if (tas.get(i).isDead())
            tas.remove(tas.get(i));
          else
            tas.get(i).draw();
        }
      }
    } else {
      fill(color(255, 0, 0));
      textSize(30);
      textAlign(CENTER);
      text("Game Over", width/2, height/2);
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
    //change
    if ((r + rWeight/2) <= (nextR + RWeight) &&
      (r - rWeight/2) >= (nextR - RWeight)) {

      String str = null;
      if ((r - nextR) <= 0.5){
        str = "Perfect +3";
        score += 3;
      }
      else if ((r - nextR) <= 1){
        str = "Nice +2";
        score += 2;
      }
      else{
        str = "Good +1";
        score += 1;
      }
      tas.add(new TextArea(mx + width - 100, my - 100, 100, 100, str));

      int newNum = int(random(80, 120));
      particleSystems.add(new ParticleSystem(int(nextR/2 + 10), newNum, nextC));

      nextR = random(100, 200);
      nextC = color(random(255), random(255), random(255));
      isLarger = r - nextR;

      timer = millis();
      if (maxTime >= 300)
        maxTime -= 5;

      playSound();
    } else
    {
      gameState = die;
    }
  }

  void playSound() {
    for (AudioPlayer ap : sounds) {
      ap.rewind();
      ap.pause();
    }
    int index = int(random(0, 7));
    sounds.get(index).play();
  }

  void checkRelease(float mx, float my) {
  }

  void checkKeyPress() {
    if (keyCode == 32)
      isCircle = !isCircle;
    if (keyCode == 49)
      speed--;
    if (keyCode == 50)
      speed++;
    println("speed: "+speed);
  }

  void  checkKeyPress(float mx, float my) {
  }
}

class SceneGame2 extends Scene {
  Audio au;
  ArrayList<Circle> cs;
  ArrayList<ParticleSystem> pss;
  ArrayList<TextArea> tas;
  int timer, maxTime;
  int lastCreatPosX, lastCreatPosY;
  PImage bg;
  int id, clickCount;
  int difficulty;
  float perfectSize, niceSize, goodSize, score,scoreSize;

  SceneGame2(int x, int y) {
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
    perfectSize = niceSize = goodSize = scoreSize = 15;
    score = 0;
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
    if (millis() - timer >= maxTime && transX == width)
      au.song.play();

    if (au.canCreat(difficulty)) {
      cs.add(new Circle(lastCreatPosX, lastCreatPosY, ++id));
      float ranx = random(100);
      float rany = random(100);
      if (ranx < 50)
        lastCreatPosX += random(-120, -100);
      else
        lastCreatPosX += random(100, 120);
      if (rany < 50)
        lastCreatPosY += random(-120, -100);
      else
        lastCreatPosY += random(100, 120);
      lastCreatPosX = constrain(lastCreatPosX, 100, width - 100);
      lastCreatPosY = constrain(lastCreatPosY, 100, height - 100);
    }
    
    perfectSize = constrain(perfectSize * 0.95, 15, 30);
    niceSize = constrain(niceSize * 0.95, 15, 30);
    goodSize = constrain(goodSize * 0.95, 15, 30);
    scoreSize = constrain(scoreSize * 0.95, 15, 30);
  }

  void display() {
    pushMatrix();
    //bg
    translate(anchor.x, anchor.y);
    image(bg, 0, 0, width, height);
    //audio
    au.display();
    //text
    fill(0);
    textSize(15);
    text("1,2,3,4 to change difficulty", width * 0.15, height * 0.1);
    text("Difficulty: " + difficulty, width * 0.15, height * 0.2);
    fill(color(0, 0, 255));
    textSize(perfectSize);
    text("Perfect", width * 0.15, height * 0.3);
    textSize(niceSize);
    text("Nice", width * 0.15, height * 0.4);
    textSize(goodSize);
    text("Good", width * 0.15, height * 0.5);
    textSize(scoreSize);
    text("Score: " + score, width * 0.15, height * 0.6);
    
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
      if (c.isInside(mx, my) && c.circleState == 1 ) {//&& (++clickCount == c.id)) {
        String str = null;
        if ((c.r - c.R) <= 5){
          str = "Good +5";
          goodSize = 30;
          score += 5;
          scoreSize = 30;
        }
        else if ((c.r - c.R) <= 10){
          str = "Nice +10";
          niceSize = 30;
          score += 10;
          scoreSize = 30;
        }
        else{
          str = "Perfect +15";
          perfectSize = 30;
          score += 15;
          scoreSize = 30;
        }
        tas.add(new TextArea(mx - width - 100, my - 100, 100, 100, str));
        pss.add(new ParticleSystem(c.x, c.y, int(c.R + 10), int(random(80, 120)), c.col));
        c.circleState = 2;
      }
    }
  }

  void checkRelease(float mx, float my) {
  }

  void  checkKeyPress() {
  }

  void checkKeyPress(float mx, float my) {
    if (keyCode == 49)
      difficulty = 1;
    else if (keyCode == 50)
      difficulty = 2;
    else if (keyCode == 51)
      difficulty = 3;
    else if (keyCode == 52)
      difficulty = 4;
    println(difficulty);

    for (int i = cs.size() - 1; i >= 0; i--) {
      Circle c = cs.get(i);
      if (c.isInside(mx, my) && c.circleState == 1 ) {//&& (clickCount == c.id)) {
        String str = null;
        if ((c.r - c.R) <= 5){
          str = "Good +5";
          goodSize = 30;
          score += 5;
          scoreSize = 30;
        }
        else if ((c.r - c.R) <= 10){
          str = "Nice +10";
          niceSize = 30;
          score += 10;
          scoreSize = 30;
        }
        else{
          str = "Perfect +15";
          perfectSize = 30;
          score += 15;
          scoreSize = 30;
        }
        tas.add(new TextArea(mx - width - 100, my - 100, 100, 100, str));
        pss.add(new ParticleSystem(c.x, c.y, int(c.R + 10), int(random(80, 120)), c.col));
        c.circleState = 2;
      }
    }
  }
}