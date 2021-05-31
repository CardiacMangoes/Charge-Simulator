class FieldLine{
  PVector v0;
  PVector v;
  
  
  FieldLine(float x_, float y_){
    v0 = new PVector(x_, y_);
  }
  
  float p(PVector v){
    return 8.9875517923 * pow(10, 9) * -2 * v.x/pow(v.x*v.x+v.y*v.y, 2);
  }
  
  float q(PVector v){
    return 8.9875517923 * pow(10, 9) * -2 * v.y/pow(v.x*v.x+v.y*v.y, 2);
  }
}
