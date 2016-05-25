import de.looksgood.ani.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;

//宽高比为16:9
final int WIDTH = 860;

void settings() {
  float ww = WIDTH;
  float hh = ww*9/16;
  size(int(ww), int(hh),P2D);
}

ArrayList<Scene>ss;
Scene   seleScene;
boolean isLockScene;

UIset      us;
UIfactory  uf;
SceneClock sc;

float transX,transY;

void setup()
{
  smooth();
  Ani.init(this);
  minim = new Minim(this);
  sc = new SceneClock();
  
  transX = 0;
  transY = 0;
  
  ss = new ArrayList<Scene>();
  ss.add(new SceneStart(0,0).load());
  ss.add(new SceneGame(1,0).load());
  
  isLockScene = true;
  seleScene = ss.get(0);
  
  //构建按钮
  us = UIset.getInstance();
  uf = new UIfactory(us);
  uf.addButton(width/2 - 50,height * 0.8,"Start",function_type.SCENE_01);
  //uf.addButton(width + width * 0.1,height * 0.05,"ReStart",function_type.SCENE_01);
}

void draw(){
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

void mousePressed(){
  if(isLockScene)
  {
    //println(seleScene.anchor.x);
    seleScene.checkPress(transX+mouseX,transY+mouseY);
  }
  us.checkPress(transX+mouseX,transY+mouseY);
}

void mouseDragged()
{
  
}

void mouseReleased(){
  us.checkRelease();
}

void keyPressed(){
  if(isLockScene)
  {
    seleScene.checkKeyPress(transX+mouseX,transY+mouseY);
  }
}