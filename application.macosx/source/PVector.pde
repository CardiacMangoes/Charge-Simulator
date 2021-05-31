class PVector {
  float x;
  float y;
  
  PVector(float x_, float y_){
    x = x_;
    y = y_;
  }
  
  void limit(float max){
    if (mag() > max){
      normalize();
      scale(max);
    }
  }
  
  void add(PVector v) {
    x = x + v.x;
    y = y + v.y;
  }
  
  void sub(PVector v) {
    x = x - v.x;
    y = y - v.y;
  }
  
  void scale(float c){
    x = x * c;
    y = y * c;
  }
  
  void divide(float c){
    x = x/c;
    y = y/c;
  }
  
  float divergence(){
    return x + y;
  }
  
  float slope(){
    return y/x;
  }
  
  float mag(){
    return sqrt(x*x + y*y);
  }
  
  void normalize() {
    float m = mag();
    if (m != 0)
      scale(1/m);
  }
  
  void setMag(float mag){ 
    normalize();
    scale(mag);
  }
  
  float dot(PVector v) {
    return x * v.x + y * v.y;
  }
  
  PVector mouse(){
    return new PVector(mouseX, mouseY);
  }
 
  PVector get(){
    return this;
  }
  
  void display(float x_, float y_){
    line(x_, y_, x_ + x, y_ - y);
  }
  
  void display(float x_, float y_, boolean arrow){
    float mag = 0.3/sqrt(2);
    if (arrow){
      line(x_ - x/2, y_ + y/2, x_ + x/2, y_ - y/2);
      line(x_ + x/2, y_ - y/2, x_ + x/2 + (-x + y) * mag, y_ - y/2 + (x + y) * mag);
      line(x_ + x/2, y_ - y/2, x_ + x/2 - (x + y) * mag, y_ - y/2 - (x - y) * mag);
      
      //line(x_ + x/2, y_ - y/2, x_ + x/2 + (x + y) * mag, y_ - y/2 - (y - x) * mag);
      //line(x_ + x/2, y_ - y/2, x_ + x/2 - (y - x) * mag, y_ - y/2 - (y + x) * mag);
    }
  }
}
