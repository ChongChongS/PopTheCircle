public enum  show_type {
 NONE, TRANSFORM, SCALE;
}

void showEvent(show_type value) {
 switch(value) {
 case TRANSFORM:
   bottomToUp();
   break;
 case SCALE:
   smallToLarge();
   break;
 default:
   println("ERROR:使用了未初始化的枚举值（show_type）");
   break;
 }
}  

void bottomToUp() {
}

void smallToLarge() {
}