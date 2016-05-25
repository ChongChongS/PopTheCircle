class Circle {
  float x, y;
  float r, R, rWeight, RWeight;
  color col;
  float speed;
  int circleState;//0:not hover 1:hover 2:die
  int id;

  Circle(float cx, float cy,int m_id) {
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

  void run()
  {
    update();
    display();
  }

  void update() {
    r -= speed;

    if ((r + rWeight/2) <= (R + RWeight) && (r - rWeight/2) >= (R - RWeight)) {
      circleState = 1;
      col = color(red(col), green(col), blue(col), 255);
    } else if ((r + rWeight/2) <= (R - RWeight))
      circleState = 2;
  }

  void display() {
    if (circleState != 2) {
      noFill();

      //R circle
      stroke(col);
      strokeWeight(RWeight);
      ellipse(x, y, R, R);

      //id
      textSize(24);
      textAlign(CENTER);
      text(id, x, y);

      //r circle
      stroke(100);
      strokeWeight(rWeight);
      ellipse(x, y, r, r);
    }
  }

  boolean isInside(float mx, float my) {
    float dis = (new PVector(mx - width, my).sub(new PVector(x, y))).mag();
    if (dis <= R/2) {
      return true;
    } else
      return false;
  }
}