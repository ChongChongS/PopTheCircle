abstract class Scene{
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

class SceneStart extends Scene{
  SceneStart(int x,int y){
    anchor = new PVector(x * width,y * height);
    size = new PVector(width,height);
  }
  
  Scene load(){
     return this;
  }
  
   void reset(){
  
  }
  
  void update(){
  
  }
  
  void display(){
    
  }
  
  void update_unlock(){
  
  }
  
  void display_unlock(){
  
  }
  
  void checkHover(float mx, float my){
  
  }
  
  void checkPress(float mx, float my){
  }
  
  void checkRelease(float mx, float my){
  
  }
}

class SceneGame extends Scene{
  SceneGame(int x,int y){
    anchor = new PVector(x * width,y * height);
    size   = new PVector(width,height);
  }
  
  Scene load(){
    return this;
  }
  
  void reset(){
  
  }
  
  void update(){
  
  }
  
  void display(){
    
  }
  
  void update_unlock(){
  
  }
  
  void display_unlock(){
  
  }
  
  void checkHover(float mx, float my){
  
  }
  
  void checkPress(float mx, float my){

  }
  
  void checkRelease(float mx, float my){
  
  }
}