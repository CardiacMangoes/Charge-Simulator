class Charge{
  PVector position;
  
  float coulomb;
  boolean down;
  PVector offset;
  boolean moved;
  
  float radius;
  
  //constructor for charge
  Charge(float x_, float y_, float charge_){
    position = new PVector(x_, y_);
    coulomb = charge_/zoom;
    radius = 10;
    down = false;
    moved = true;
    ellipseMode(RADIUS);
  }
  
  //moves charge to position x_ y_
  void move(float x_, float y_){
    position = new PVector(x_, y_);
    moved = true;
  }
  
  //returns whether charge is positive or negative
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
    ellipse(position.x, position.y, radius, radius);
  }
  
  float distance(float x_, float y_){
    return(sqrt(pow(position.x - x_, 2) + pow(position.y - y_, 2)));
  }
  
  //mouse drag
  void drag(){
    moved = false;
    if (down == true && mousePressed){
      move(mouseX - offset.x, mouseY - offset.y);
    } else {
      down = false;
    }
  }
  
  //mouse double clicked
  void doubleClicked(){
    if (distance(mouseX, mouseY) < radius) {
      coulomb *= -1;
      moved = true;
    }
  }
  
  //mouse single clicked
  void mousePress(){
    if (distance(mouseX, mouseY) < radius && !down){
      offset = new PVector(mouseX - position.x, mouseY - position.y);
      down = true;
    }
  }
  
}
