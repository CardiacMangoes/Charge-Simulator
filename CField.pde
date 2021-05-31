class CField extends VField{
  Charge charge;
  float[] divergence;
  
  float[] mdivergence;
  PVector[] mfield;
  
  CField(int width_, int height_, int scale_, Charge charge_){
    super(width_, height_, scale_);
    charge = charge_;
    divergence = new float[(width_/scale + 1) * (height_/scale + 1)];
    mfield = field;
    mdivergence = divergence;
  }
  
  void move(float x_, float y_){
    charge.move(x_, y_);
  }
  
  void update(){
    if (charge.moved) {
      mfield = field.clone();
      mdivergence = divergence.clone();
      for (i = 0; i <= width_/scale; i++){
        for (j = 0; j <= height_/scale; j++){
          ndx();
          float x = -(i * scale - charge.position.x);
          float y = (j * scale - charge.position.y);
          PVector v = new PVector(x, y);
          //if(i == 5 && j == 5) println("(" + x + ", " + y + ")");
          field[ndx] = new PVector(charge.coulomb * p(v), charge.coulomb * q(v));
          //if(i == 5 && j == 5) println("(" + field[ndx].x + ", " + field[ndx].y + ") charge: " + charge.coulomb);    
          //if (Float.compare(x, 0) != 0 && Float.compare(y, 0) != 0)
            divergence[ndx] = charge.coulomb * div(v);
          //if(i == 5 && j == 5) println("divergence: " + divergence[ndx] + " distance:" + sqrt(pow(field[ndx].x, 2) + pow(field[ndx].y, 2)));    
        }
      }
    }
  }
  
  void divColor(){
    float prim = map(zoom / 2 * (abs(divergence[ndx])), 0 , 100, 127.5, 255) ; 
    prim = prim >= 255 ? 255 : prim;
    if (divergence[ndx] > 0) stroke(prim, 0, 255-prim);
    else stroke(255-prim, 0, prim);
    //if(i == 5 && j == 5) stroke(255, 255, 0);  
  }
  
  void display(){
    for (i = 0; i <= width_/scale; i++){
      for (j = 0; j <= height_/scale; j++){
        ndx();
        divColor();
        displayV();
      }
    }
    charge.display();
  }
  
  float p(PVector v){
    return 8.9875517923 * pow(10, 9) * -2 * v.x/pow(v.x*v.x+v.y*v.y, 2);
  }
  
  
  float q(PVector v){
    return 8.9875517923 * pow(10, 9) * -2 * v.y/pow(v.x*v.x+v.y*v.y, 2);
  }
  
  //finds divergence of vector
  float div(PVector v){
    return 8.9875517923 * pow(10, 9) * 4 / pow(v.x*v.x+v.y*v.y, 2);
  }
  
}
