class Charge extends PVector{
  int coulomb;
  boolean down;
  PVector offset;
  boolean moved;
  
  int radius = 10;
  
  Charge(float x_, float y_, int charge_){
    super(x_, y_);
    coulomb = charge_;
    down = false;
    moved = true;
  }
  
  void move(float x_, float y_){
    x = x_;
    y = y_;
    moved = true;
  }
  
  boolean sign() {
    return coulomb > 0 ? true :false;
  }
  
  void display(){
    noStroke();
    drag();
    if(sign())
      fill(255, 0 ,0);
    else
      fill(0, 0, 255);
    ellipse(x, y, radius * 2, radius * 2);
  }
  
  float distance(float x_, float y_){
    return(sqrt(pow(x - x_, 2) + pow(y - y_, 2)));
  }
  
  void drag(){
    if (down == true && mousePressed){
      move(mouseX - offset.x, mouseY - offset.y);
      moved = true;
    } else {
      down = false;
    }
  }
  
  void doubleClicked(){
    if (distance(mouseX, mouseY) < radius) {
      coulomb *= -1;
      moved = true;
    }
  }
  
  void mousePress(){
    if (distance(mouseX, mouseY) < radius && !down){
      offset = new PVector(mouseX - x, mouseY - y);
      down = true;
    }
  }
  
}
