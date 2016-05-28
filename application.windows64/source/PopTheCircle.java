import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import de.looksgood.ani.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class PopTheCircle extends PApplet {




  
Minim minim;

//\u5bbd\u9ad8\u6bd4\u4e3a16:9
final int WIDTH = 860;

public void settings(){
  float ww = WIDTH;
  float hh = ww*9/16;
  size(PApplet.parseInt(ww),PApplet.parseInt(hh),P2D);
}

//\u5168\u5c40\u53d8\u91cf
ArrayList<Scene>ss;
Scene   seleScene;
boolean isLockScene;

UIset      us;
UIfactory  uf;
SceneClock sc;

float transX,transY;

public void setup(){
  
  Ani.init(this);
  minim = new Minim(this);
  sc = new SceneClock();
  
  transX = 0;
  transY = 0;
  
  ss = new ArrayList<Scene>();
  ss.add(new SceneStart(0,0).load());
  ss.add(new SceneGame2(1,0).load());
  ss.add(new SceneGame(-1,0).load());
  
  isLockScene = true;
  seleScene = ss.get(0);
  
  //\u6784\u5efa\u6309\u94ae
  us = UIset.getInstance();
  uf = new UIfactory(us);
  uf.addButton(width/2 - 100,height * 0.8f,"Game2",function_type.SCENE_01);
  uf.addButton(width/2,height * 0.8f,"Game1",function_type.SCENE_03);
  uf.addButton(-width + width * 0.05f,height * 0.05f,"Back",function_type.SCENE_02);
  uf.addButton(-width + width * 0.05f,height * 0.05f + 50,"ReStart",function_type.SCENE_03);
}

public void draw(){
  sc.update();
  
  translate(-transX,-transY);
  
  if(!isLockScene)
  {
    for(Scene s: ss){
      s.update();
      s.display();
    }
  }
  else{
    seleScene.update();
    seleScene.display();
  }
  
  us.checkHover(transX+mouseX,transY+mouseY);
  us.display();
}

public void mousePressed(){
  if(isLockScene)
  {
    //println(seleScene.anchor.x);
    seleScene.checkPress(transX+mouseX,transY+mouseY);
  }
  us.checkPress(transX+mouseX,transY+mouseY);
}

public void mouseDragged()
{
  
}

public void mouseReleased(){
  us.checkRelease();
}

public void keyPressed(){
  if(isLockScene){
    seleScene.checkKeyPress();
    seleScene.checkKeyPress(transX+mouseX,transY+mouseY);
  }
}
class Audio {
  AudioPlayer song;
  BeatDetect beat;
  BeatListener bl;
  FFT fft;

  Audio() {
    song = minim.loadFile("bgm.mp3", 2048);

    beat = new BeatDetect(song.bufferSize(), song.sampleRate());
    beat.setSensitivity(300);  

    bl = new BeatListener(beat, song);

    fft = new FFT( song.bufferSize(), song.sampleRate() );
  }

  public boolean canCreat(int id) {
    switch(id) {
      case 1:
        if(beat.isKick() && beat.isSnare())
          return true;
        else
          return false;
      case 2:
        if(beat.isKick())
          return true;
        else
          return false;
      case 3:
        if(beat.isKick() || beat.isSnare())
          return true;
        else
          return false;
      case 4:
        if(beat.isKick() || beat.isHat())
          return true;
        else
          return false;
      default:
        return false;
    }
  }

  public void display() {
    stroke(255);
    fft.forward(song.mix);
    for (int i = 0; i < fft.specSize(); i++)
    {
      line( i, height, i, height - fft.getBand(i)*8 );
    }
  }
}
class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;

  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  public void samples(float[] samps)
  {
    beat.detect(source.mix);
  }

  public void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}
class Circle {
  float x, y;
  float r, R, rWeight, RWeight;
  int col;
  float speed;
  int circleState;//0:not hover 1:hover 2:die
  int id;

  Circle(float cx, float cy, int m_id) {
    x = cx;
    y = cy;

    rWeight = 4;
    RWeight = 20;
    R = random(50, 100);
    r = R + RWeight + 5;

    col = color(random(255), random(255), random(255), 200);
    speed = 1;
    circleState = 0;
    id = m_id;
  }

  public void run()
  {
    update();
    display();
  }

  public void update() {
    r -= speed;

    if ((r + rWeight/2) <= (R + RWeight) && (r - rWeight/2) >= (R - RWeight)) {
      circleState = 1;
      col = color(red(col), green(col), blue(col), 255);
    } else if ((r + rWeight/2) <= (R - RWeight))
      circleState = 2;
  }

  public void display() {
    if (circleState != 2) {

      noFill();

      //R circle
      stroke(col);
      strokeWeight(RWeight);
      ellipse(x, y, R, R);

      //r circle
      stroke(100);
      strokeWeight(rWeight);
      ellipse(x, y, r, r);

      //id
      textSize(24);
      textAlign(CENTER);
      fill(0);
      text(id, x, y);
    }
  }

  public boolean isInside(float mx, float my) {
    float dis = (new PVector(mx - width, my).sub(new PVector(x, y))).mag();
    if (dis <= R/2) {
      return true;
    } else
      return false;
  }
}
//\u679a\u4e3e\u7c7b\u578b function_enum
public enum function_type {
  NONE, SCENE_01, SCENE_02, SCENE_03;
}

public void doEvent(function_type value) {
  switch(value) {
  case NONE:     
    println("none function");
    break;
  case SCENE_01: 
    changeToGameView(); 
    break;
  case SCENE_02: 
    changeToStartMenu();
    break;
  case SCENE_03: 
    changeToGameView2();
    break;
  default: 
    println("ERROR\uff1a\u4f7f\u7528\u4e86\u672a\u521d\u59cb\u5316\u7684\u679a\u4e3e\u503c\uff08function_enum\uff09"); 
    break;
  }
}

public void changeToGameView() {
  println("scene01 function");
  ss.get(1).reset();
  sc.moveToScene(ss.get(1));
}

public void changeToGameView2() {
  println("scene03 function");
  ss.get(2).reset();
  sc.moveToScene(ss.get(2));
}

public void changeToStartMenu() {
  println("scene02 function");
  sc.moveToScene(ss.get(0));
}

class SceneClock {
  int startTime;
  int waitTime;
  boolean isOver;
  Scene   toLerp;

  SceneClock() {
    isOver = true;
  }

  public void moveToScene(Scene ns) {
    isLockScene = false;
    isOver = false;
    float time = 0.9f;
    toLerp = ns;
    PVector pos;
    pos = ns.anchor.copy();
    println(pos);
    startTime = millis();
    waitTime  = (int)(time*1000);
    move(time, pos);
  }

  public void update() {
    if (!isOver) {
      if (millis()>startTime+waitTime) {
        isOver = false;
        seleScene = toLerp;
        isLockScene = true;
      }
    }
  }
}

public void move(float time, PVector pos) {
  Ani.to(this, time, "transX", pos.x, Ani.CUBIC_IN_OUT);
  Ani.to(this, time, "transY", pos.y, Ani.CUBIC_IN_OUT);
}
class Particle {
  PVector loc;
  float lifespan;
  int R;
  int col;
  float r,cx,cy;

  Particle(int mCol, int mR) {
    col = mCol;
    R = mR;
    lifespan = 255.0f;
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
  
  Particle(float x,float y,int mCol, int mR) {
    col = mCol;
    R = mR;
    lifespan = 255.0f;
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
  
  public void run() {
    update();
    display();
  }

  // Method to update location
  public void update() {
    PVector f = new PVector(width/2,height/2).sub(loc);
    loc.add(f.normalize().mult(-0.8f));
    if(r > 3)
      r -= 0.2f;
    lifespan -= 10.0f;
  }

  // Method to display
  public void display() {
    fill(col, lifespan);
    noStroke();
    ellipse(loc.x, loc.y, r, r);
  }

  // Is the particle still useful?
  public boolean isDead() {
    if (lifespan <= 0.0f) {
      return true;
    } else {
      return false;
    }
  }
}
class ParticleSystem {

  ArrayList<Particle> particles;
  int R;
  float locX,locY;

  ParticleSystem(int R, int num, int col) {
    locX = 0;
    locY = 0;
    particles = new ArrayList<Particle>();        
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(col, R));
    }
  }
  
  ParticleSystem(float cx,float cy,int R, int num, int col) {
    locX = cx;
    locY = cy;
    
    particles = new ArrayList<Particle>();        
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(cx,cy,col, R));
    }
  }

  public void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  // A method to test if the particle system still has particles
  public boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }
  
}
abstract class Scene {
  PVector anchor;
  PVector size;

  public abstract Scene load();
  public abstract void  reset();
  public abstract void  update();
  public abstract void  display();
  public abstract void  update_unlock();
  public abstract void  display_unlock();

  public abstract void  checkHover(float mx, float my);
  public abstract void  checkPress(float mx, float my);
  public abstract void  checkRelease(float mx, float my);
  public abstract void  checkKeyPress();
  public abstract void  checkKeyPress(float mx, float my);
}

class SceneStart extends Scene {
  float theta;

  SceneStart(int x, int y) {
    anchor = new PVector(x * width, y * height);
    size = new PVector(width, height);
  }

  public Scene load() {
    println("Scene Start");
    return this;
  }

  public void reset() {
  }

  public void update() {
  }

  public void display() {
    pushMatrix();
    translate(anchor.x, anchor.y);
    fill(255);
    noStroke();
    rect(0, 0, size.x, size.y);

    theta = map(mouseY, 0, height, 0, PI/2);
    translate(width/2, height * 0.8f);
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

  public void update_unlock() {
  }

  public void display_unlock() {
  }

  public void checkHover(float mx, float my) {
  }

  public void checkPress(float mx, float my) {
  }

  public void checkRelease(float mx, float my) {
  }

  public void  checkKeyPress() {
  }

  public void  checkKeyPress(float mx, float my) {
  }

  public void branch(float len) {
    float sw = map(len, 2, 120, 1, 10);
    strokeWeight(sw);

    line(0, 0, 0, -len);
    translate(0, -len);

    len *= 0.66f;
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
  //\u5706
  float r, nextR, isLarger;
  float rWeight, RWeight;
  int nextC;
  float speed;
  public boolean isCircle;
  //\u6e38\u620f\u72b6\u6001
  final int die = 0;
  final int running = 1;
  final int stop = 2; 
  int gameState;
  //\u5173\u4e8e\u7c92\u5b50
  ArrayList<ParticleSystem> particleSystems;
  //\u6bcf\u56de\u5408\u7684\u6682\u505c
  int timer, maxTime;
  //\u6e38\u620f\u97f3\u6548
  ArrayList<AudioPlayer> sounds;
  //\u663e\u793a\u6587\u5b57\u4e0e\u56fe\u7247
  ArrayList<TextArea> tas;
  int score;
  PImage bg;

  SceneGame(int x, int y) {
    anchor = new PVector(x * width, y * height);
    size   = new PVector(width, height);

    init();
  }

  public void init() {
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

  public Scene load() {
    println("scene game");
    return this;
  }

  public void reset() {
    println("reset");
    init();
  }

  public void update() {
    if (millis() - timer >= maxTime) {
      if (gameState == running) {

        //\u7f29\u653e\u5706\u5708  
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
          Ani.to(this, 0.2f, "r", height * 2, Ani.BOUNCE_IN_OUT);
        sounds.get(0).pause();
      }
    }
  }

  public void display() {
    pushMatrix();
    translate(anchor.x, anchor.y);
    fill(0xfff2eada);
    noStroke();
    rect(0, 0, size.x, size.y);
    fill(0);
    textSize(15);
    text("space to change shape", width * 0.15f, height * 0.3f);
    text("1 speed down,2 speed up", width * 0.15f, height * 0.4f);
    text("speed: " + speed, width * 0.1f, height * 0.5f);
    text("score: " + score, width * 0.1f, height * 0.6f);
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

  public void update_unlock() {
  }

  public void display_unlock() {
  }

  public void checkHover(float mx, float my) {
  }

  public void checkPress(float mx, float my) {
    //change
    if ((r + rWeight/2) <= (nextR + RWeight) &&
      (r - rWeight/2) >= (nextR - RWeight)) {

      String str = null;
      if ((r - nextR) <= 0.5f){
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

      int newNum = PApplet.parseInt(random(80, 120));
      particleSystems.add(new ParticleSystem(PApplet.parseInt(nextR/2 + 10), newNum, nextC));

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

  public void playSound() {
    for (AudioPlayer ap : sounds) {
      ap.rewind();
      ap.pause();
    }
    int index = PApplet.parseInt(random(0, 7));
    sounds.get(index).play();
  }

  public void checkRelease(float mx, float my) {
  }

  public void checkKeyPress() {
    if (keyCode == 32)
      isCircle = !isCircle;
    if (keyCode == 49)
      speed--;
    if (keyCode == 50)
      speed++;
    println("speed: "+speed);
  }

  public void  checkKeyPress(float mx, float my) {
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

  public void init() {
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

  public Scene load() {
    println("scene game");
    return this;
  }

  public void reset() {
    println("reset");
    init();
  }

  public void update() {
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
    
    perfectSize = constrain(perfectSize * 0.95f, 15, 30);
    niceSize = constrain(niceSize * 0.95f, 15, 30);
    goodSize = constrain(goodSize * 0.95f, 15, 30);
    scoreSize = constrain(scoreSize * 0.95f, 15, 30);
  }

  public void display() {
    pushMatrix();
    //bg
    translate(anchor.x, anchor.y);
    image(bg, 0, 0, width, height);
    //audio
    au.display();
    //text
    fill(0);
    textSize(15);
    text("1,2,3,4 to change difficulty", width * 0.15f, height * 0.1f);
    text("Difficulty: " + difficulty, width * 0.15f, height * 0.2f);
    fill(color(0, 0, 255));
    textSize(perfectSize);
    text("Perfect", width * 0.15f, height * 0.3f);
    textSize(niceSize);
    text("Nice", width * 0.15f, height * 0.4f);
    textSize(goodSize);
    text("Good", width * 0.15f, height * 0.5f);
    textSize(scoreSize);
    text("Score: " + score, width * 0.15f, height * 0.6f);
    
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

  public void update_unlock() {
  }

  public void display_unlock() {
  }

  public void checkHover(float mx, float my) {
  }

  public void checkPress(float mx, float my) {
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
        pss.add(new ParticleSystem(c.x, c.y, PApplet.parseInt(c.R + 10), PApplet.parseInt(random(80, 120)), c.col));
        c.circleState = 2;
      }
    }
  }

  public void checkRelease(float mx, float my) {
  }

  public void  checkKeyPress() {
  }

  public void checkKeyPress(float mx, float my) {
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
        pss.add(new ParticleSystem(c.x, c.y, PApplet.parseInt(c.R + 10), PApplet.parseInt(random(80, 120)), c.col));
        c.circleState = 2;
      }
    }
  }
}
public enum  show_type {
 NONE, TRANSFORM, SCALE;
}

public void showEvent(show_type value) {
 switch(value) {
 case TRANSFORM:
   bottomToUp();
   break;
 case SCALE:
   smallToLarge();
   break;
 default:
   println("ERROR:\u4f7f\u7528\u4e86\u672a\u521d\u59cb\u5316\u7684\u679a\u4e3e\u503c\uff08show_type\uff09");
   break;
 }
}  

public void bottomToUp() {
}

public void smallToLarge() {
}
//\u57fa\u7840\u533a\u57df

//\u77e9\u5f62\u533a\u57df
class RectArea {
  PVector pos;
  PVector size;

  RectArea(float xx, float yy, float ww, float hh) {
    pos  = new PVector(xx, yy);
    size = new PVector(ww, hh);
  }

  RectArea(PVector ppos, PVector psize) {
    pos     = ppos.copy();
    size    = psize.copy();
  }

  public boolean isIn(float mx, float my) {
    if (mx>pos.x && mx<pos.x+size.x && my>pos.y && my<pos.y+size.y) {
      return true;
    } else {
      return false;
    }
  }
}

//\u8fd9\u91cc\u7684KnowMouseArea\u548cClickable\u5728\u7ed3\u6784\u4e0a\u5341\u5206\u76f8\u50cf
//\u4f46\u662f\u4e3a\u4e86\u6574\u4f53\u7684\u4f4e\u8026\u5408\u6027\u5fc5\u987b\u8981\u5206\u51fa\u6765\uff0c\u5373\uff1a\u7ed8\u56fe\u4e0e\u903b\u8f91\u5206\u5f00

//\u7ed8\u5236\u63a5\u53e3
interface KnowMouseArea
{
  public boolean isIn(float mx, float my);
  public void    draw();
  public void    click();
  public void    drag();
  public void    release();
}

class TextArea extends RectArea {
  final int  default_text_base_color       = color(255, 0, 0);
  final String default_str                   = "score";
  final int    default_font_size             = 24;

  String str;
  int    fontSize;
  int  textBaseCol;
  PFont  sysFont;
  int lifespan;
  show_type value;

  public void setDefaults() {
    textBaseCol    = default_text_base_color;
    str            = default_str;
    fontSize       = default_font_size;
    sysFont        = null;
    value          = show_type.NONE;
    lifespan       = 255;
  }

  TextArea(float xx, float yy, float ww, float hh, String name) {
    super(xx, yy, ww, hh);
    setDefaults();
    str = name;
  }

  public TextArea setFont(PFont pf) {
    sysFont = pf;
    return this;
  }
  
  public boolean isDead(){
    if(lifespan <= 0)
      return true;
    else
      return false;
  }
  
  public void draw() {
    lifespan -= 5;
    
    pushMatrix();
    translate(pos.x, pos.y);
    fill(textBaseCol,lifespan);

    if (sysFont!=null)
      textFont(sysFont, fontSize);
    else 
      textSize(fontSize);

    textAlign(CENTER);
    text(str, size.x, size.y);

    popMatrix();
  }
}

//\u7528\u591a\u79cd\u989c\u8272\u7ed8\u5236\u7684\u77e9\u5f62\u533a\u57df\uff08\u80fd\u611f\u77e5\u5230\u9f20\u6807\uff09
class ColorSetRectArea extends RectArea implements KnowMouseArea
{
  //\u5e38\u91cf
  final  int  default_base_color            = color(255);
  final  int  default_hover_color           = color(100);
  final  int  default_clicked_color         = color(0);
  final  int  default_text_base_color       = color(0);
  final  int  default_text_hover_color      = color(0);
  final  int  default_text_clicked_color    = color(255);
  final  String default_str                   = "Butt";
  final  int    default_font_size             = 24;


  String str;
  int    fontSize;
  int  baseCol;
  int  hoverCol;
  int  clickedCol;
  int  textBaseCol;
  int  textHoverCol;
  int  textClickedCol;

  boolean isInside;
  boolean isClicked;
  PFont   sysFont;

  public void setDefaults() {
    baseCol        = default_base_color;
    hoverCol       = default_hover_color;
    clickedCol     = default_clicked_color;
    textBaseCol    = default_text_base_color;
    textHoverCol   = default_text_hover_color;
    textClickedCol = default_text_clicked_color;
    str            = default_str;
    fontSize       = default_font_size;
    sysFont        = null;
  }


  ColorSetRectArea(float xx, float yy, float ww, float hh) {
    super(xx, yy, ww, hh);
    setDefaults();
  }

  ColorSetRectArea(float xx, float yy, float ww, float hh, String butName) {
    super(xx, yy, ww, hh);
    setDefaults();
    str = butName;
  }

  ColorSetRectArea(PVector ppos, PVector psize) {
    super(ppos, psize);
    setDefaults();
  }

  public ColorSetRectArea setFont(PFont pf) {
    sysFont = pf;
    return this;
  }

  public boolean isIn(float mx, float my) {
    isInside = super.isIn(mx, my);
    return isInside;
  }

  public void click() {
    isClicked = true;
  }

  public void drag() {
  }

  public void release() {
    isClicked = false;
  }

  public void draw() {
    pushMatrix();

    translate(pos.x, pos.y);

    noStroke();

    fill(baseCol);
    if (isInside)  fill(hoverCol);
    if (isClicked) fill(clickedCol);

    rect(0, 0, size.x, size.y);

    fill(textBaseCol);
    if (isInside)  fill(textHoverCol);
    if (isClicked) fill(textClickedCol);
    if (sysFont!=null)
    {
      textFont(sysFont, fontSize);
    } else {
      textSize(fontSize);
    }
    textAlign(CENTER);
    text(str, size.x/2, size.y/1.2f);

    popMatrix();
  }
}

//\u679a\u4e3e\u7c7b\u578b button_type_enum
public enum button_type {
  DEFAULT_BUTT, IMAGE_BUTT;
}


class uiButton implements Clickable
{
  //\u5e38\u91cf
  static final float default_w = 100;
  static final float default_h = 30;

  KnowMouseArea area;
  function_type value;

  uiButton(float xx, float yy)
  {
    area  = new ColorSetRectArea(xx, yy, default_w, default_h);
    value = function_type.NONE;
  }

  uiButton(float xx, float yy, String butName)
  {
    area  = new ColorSetRectArea(xx, yy, default_w, default_h, butName);
    value = function_type.NONE;
  }

  public uiButton link(function_type val) {
    value = val;
    return this;
  }

  public boolean isIn(float mx, float my)
  {
    return area.isIn(mx, my);
  }

  public void draw()
  {
    area.draw();
  }
  public void clickEvent()
  {
    area.click();
    doEvent(value);
  }

  public void releaseEvent()
  {
    area.release();
  }
}

class UIfactory {
  PFont pf;
  UIset tus;

  UIfactory(UIset pus) {
    pf   = createFont("Arial", 40);
    tus  = pus;
  }

  public void addButton(float xx, float yy) {
    uiButton nb = new uiButton(xx, yy);
    tus.add(nb);
  }

  public void addButton(float xx, float yy, function_type val) {
    uiButton nb = new uiButton(xx, yy).link(val);
    tus.add(nb);
  }

  public void addButton(float xx, float yy, String butName, function_type val) {
    uiButton nb = new uiButton(xx, yy, butName).link(val);
    tus.add(nb);
  }
}

//\u63a5\u53e3
interface Clickable {
  public boolean isIn(float mx, float my); //\u786e\u8ba4\u6709\u6ca1\u6709\u5904\u4e8e\u8303\u56f4
  public void    draw();                   //\u7ed8\u5236
  public void    clickEvent();             //\u89e6\u53d1\u70b9\u51fb\u4e8b\u4ef6
  public void    releaseEvent();           //\u89e6\u53d1\u91ca\u653e\u4e8b\u4ef6
}

//\u679a\u4e3e\u7c7b\u578b proxy_enum
public enum proxy_ui {
  NULL_UI, CLICK_UI;
}

//\u53ef\u64cd\u7eb5UI\u4ee3\u7406\u7c7b
public static class uiProxy {

  static uiProxy instance = null;
  Clickable   ck;
  proxy_ui    superType;

  private uiProxy() {
    ck        = null;
    superType = proxy_ui.NULL_UI;
  }

  public static uiProxy getInstance() {
    if (instance==null) {
      return new uiProxy();
    } else {
      return instance;
    }
  }

  public void setSele(Clickable pck) {
    ck = pck;
    superType = proxy_ui.CLICK_UI;
  }

  public void selePress() {
    switch(superType) {
    case NULL_UI: 
      break;
    case CLICK_UI: 
      ck.clickEvent(); 
      break;
    }
  }

  public void seleRelease() {
    switch(superType) {
    case NULL_UI: 
      break;
    case CLICK_UI: 
      ck.releaseEvent(); 
      break;
    }
  }

  public void seleDrag() {
    switch(superType) {
    case NULL_UI: 
      break;
    case CLICK_UI: 
      break;
    }
  }

  public boolean hasSele() {
    if (superType!=proxy_ui.NULL_UI) {
      return true;
    } else
    {
      return false;
    }
  }

  public void setNull() {
    superType = proxy_ui.NULL_UI;
  }
}

class cf {
  PFont pf;
  cf() {
    pf = createFont("Arial", 40);
  }

  public PFont getFont() {
    return pf;
  }
}

//\u5355\u4f8b
public static class UIset {
  //\u5b9e\u4f8b\u57df
  ArrayList<Clickable> cks;      //\u53ef\u70b9\u51fb\u5217\u8868
  uiProxy seleUp;                //\u9009\u4e2d\u7684ui\u7ec4\u4ef6  

  //\u51fd\u6570\u57df

  //\u5185\u90e8\u7c7b\u6301\u6709\u552f\u4e00\u5f15\u7528
  static class Holder {
    static final UIset set = new UIset();
  }
  //\u83b7\u53d6\u552f\u4e00\u5f15\u7528\u7684\u51fd\u6570
  public static UIset getInstance() {
    return Holder.set;
  }



  //\u79c1\u6709\u7684\u6784\u9020\u51fd\u6570
  private UIset() { 
    cks     = new ArrayList<Clickable>();
    seleUp  = uiProxy.getInstance();
  }

  public void add(Clickable ck) {
    cks.add(ck);
  }


  public void checkHover(float mx, float my) {
    for (Clickable ck : cks) {
      if (ck.isIn(mx, my)) {
        seleUp.setSele(ck);
      }
    }
  }

  public void checkPress(float mx, float my) {
    seleUp.setNull();
    checkHover(mx, my);
    if (seleUp.hasSele()) {
      seleUp.selePress();
    }
  }

  public void checkRelease() {
    if (seleUp.hasSele()) {
      seleUp.seleRelease();
    }
  }


  public void display() {
    for (Clickable ck : cks) {
      ck.draw();
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "PopTheCircle" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
