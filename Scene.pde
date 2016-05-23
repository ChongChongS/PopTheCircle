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
  float speed;

  final int die = 0;
  final int running = 1;
  final int stop = 2;
  int gameState;

  ArrayList<ParticleSystem> particleSystems;
  int timer, maxTime;

  AudioPlayer sound1;
  AudioPlayer sound2;
  AudioPlayer sound3;
  AudioPlayer sound4;
  AudioPlayer sound5;
  AudioPlayer sound6;
  AudioPlayer sound7;

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
    speed = (r - nextR)%200;

    gameState = running;

    particleSystems = new ArrayList<ParticleSystem>();

    maxTime = 800;
    timer = millis();

    sound1 = minim.loadFile("sound1.mp3");
    sound2 = minim.loadFile("sound2.mp3");
    sound3 = minim.loadFile("sound3.mp3");
    sound4 = minim.loadFile("sound4.mp3");
    sound5 = minim.loadFile("sound5.mp3");
    sound6 = minim.loadFile("sound6.mp3");
    sound7 = minim.loadFile("sound7.mp3");
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
        //设定速度
        if (isLarger <= 100)
          speed = 1;
        else if (isLarger <= 200)
          speed = 2;
        else
          speed = 3;
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
      }

      if (gameState == die)
      {
        //if (isLarger  >= 0) {
        //println(r + rWeight/2);
        //println(nextR - RWeight/2 + "---");
        //} else {
        //println(r - rWeight/2);
        //println(nextR + RWeight/2 + "---");
        //}
      }
    }
  }

  void display() {
    pushMatrix();
    translate(anchor.x, anchor.y);
    fill(#f2eada);
    noStroke();
    rect(0, 0, size.x, size.y);

    if (gameState == running) {
      noFill();

      //next circle
      stroke(nextC);
      strokeWeight(RWeight);
      ellipse(width/2, height/2, nextR, nextR);
      strokeWeight(0);
      stroke(255);
      //line(width/2, height/2, width/2 - nextR/2 - RWeight/2, height/2);

      //the circle
      stroke(100);
      strokeWeight(rWeight);
      ellipse(width/2, height/2, r, r);
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
    sound1.rewind();
    sound1.pause();
    sound2.rewind();
    sound2.pause();
    sound3.rewind();
    sound3.pause();
    sound4.rewind();
    sound4.pause();
    sound5.rewind();
    sound5.pause();
    sound6.rewind();
    sound6.pause();
    sound7.rewind();
    sound7.pause();

    int temp = int(random(1, 8));
    switch(temp) {
    case 1:
      sound1.play();
      break;
    case 2:
      sound2.play();
      break;
    case 3:
      sound3.play();
      break;
    case 4:
      sound4.play();
      break;
    case 5:
      sound5.play();
      break;
    case 6:
      sound6.play();
      break;
    case 7:
      sound7.play();
      break;
    default:
      sound1.play();
      break;
    }
  }

  void checkRelease(float mx, float my) {
  }
}

class SceneOver extends Scene {
  SceneOver(int x, int y) {
    anchor = new PVector(x * width, y * height);
    size = new PVector(width, height);
  }

  Scene load() {
    println("Scene Over");
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