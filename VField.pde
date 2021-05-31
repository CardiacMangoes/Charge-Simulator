class VField {
  int width_;
  int height_;
  int scale;
  PVector[] field; //raw values
  PVector[] dfield; //display values
  
  int ndx;
  int i;
  int j;
  
  VField(int _width_, int _height_, int scale_){
    width_ = _width_;
    height_ = _height_;
    scale = scale_;
    field = new PVector[(width_/scale + 1) * (height_/scale + 1)];
    dfield = new PVector[(width_/scale + 1) * (height_/scale + 1)];
    for (i = 0; i <= width_/scale; i++){
      for (j = 0; j <= height_/scale; j++){
        field[ndx()] = new PVector(0, 0);
      }
    }
  }
  
  int ndx(){
    ndx = i * (width_/scale + 1) + j;;
    return ndx;
  }
  
  void displayV(){
    dfield[ndx] = field[ndx].clone();
    dfield[ndx].limit(scale * 9/10);
    dfield[ndx].display(i * scale + (width_ % scale) / 2, j * scale + (height_ % scale) / 2, true);
  }
  
  PVector get(int ndx){
    return field[ndx];
  }
}
