import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class coulomb_field extends PApplet {

EField efield;
CField[] chargeFields;
int scale = 40; //resolution of vector field
int num_charges =  10;

int num_calls = 0;

public void setup() {
  
  chargeFields = new CField[num_charges];
  for (int c = 0; c < num_charges; c++)
    chargeFields[c] = new CField(width, height, scale, new Charge(random(width/10, width * 9/10), random(height/10, height * 9/10), randCharge()));
  efield = new EField(width, height, scale, num_charges);
  efield.addCFields(chargeFields);
}

public void draw() {
  //noLoop();
  clear();
  background(0);
  stroke(255,0,0);
  strokeWeight(2);
  
  efield.update();
  efield.display();
  
  //println(frameRate);
}

public int randCharge(){
  return (-1 + (int)random(2) * 2);
}

public void mousePressed(){
  for (int c = 0; c < num_charges; c++)
    chargeFields[c].charge.mousePress();

}

public void mouseClicked(MouseEvent evt) {
  if (evt.getCount()%2 == 0)
    for (int c = 0; c < num_charges; c++)
      chargeFields[c].charge.doubleClicked();
}
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
  
  public void move(float x_, float y_){
    charge.move(x_, y_);
  }
  
  public void set(){
    mfield = field.clone();
    mdivergence = divergence.clone();
  }
  
  public void update(){
    if (charge.moved) {
      set();
      for (i = 0; i <= width_/scale; i++){
        for (j = 0; j <= height_/scale; j++){
          ndx();
          float x = -(i * scale - charge.x);
          float y = (j * scale - charge.y);
          PVector v = new PVector(x, y);
          //if(i == 5 && j == 5) println("(" + x + ", " + y + ")");
          field[ndx] = new PVector(charge.coulomb * p(v), charge.coulomb * q(v));
          //if(i == 5 && j == 5) println("(" + field[ndx].x + ", " + field[ndx].y + ") charge: " + charge.coulomb);    
          if (Float.compare(x, 0) != 0 && Float.compare(y, 0) != 0)
            divergence[ndx] = charge.coulomb * div(v);
        }
      }
    }
    charge.moved = false;
  }
  
  public void divColor(){
    float prim = map((abs(divergence[ndx])), 0 , 100, 127.5f, 255) ; 
    prim = prim >= 255 ? 255 : prim;
    if (divergence[ndx] > 0) stroke(prim, 0, 255-prim);
    else stroke(255-prim, 0, prim);
    //if(i == 5 && j == 5) stroke(255, 255, 0);  
  }
  
  public void scaleV(){
    field[ndx].divide(100);
    field[ndx].limit(scale * 4/5);
  }
  
  public void display(){
    for (i = 0; i <= width_/scale; i++){
      for (j = 0; j <= height_/scale; j++){
        ndx();
        divColor();
        scaleV();
        displayV();
      }
    }
      charge.display();
    }
    
  
  public float p(PVector v){
    return 8.9875517923f * pow(10, 9) * -2 * v.x/pow(v.x*v.x+v.y*v.y, 2);
  }
  
  public float q(PVector v){
    return 8.9875517923f * pow(10, 9) * -2 * v.y/pow(v.x*v.x+v.y*v.y, 2);
  }
  
  public float div(PVector v){
    return 8.9875517923f * pow(10, 9) * 4 / pow(v.x*v.x+v.y*v.y, 2);
  }
  
}
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
  
  public void move(float x_, float y_){
    x = x_;
    y = y_;
    moved = true;
  }
  
  public boolean sign() {
    return coulomb > 0 ? true :false;
  }
  
  public void display(){
    noStroke();
    drag();
    if(sign())
      fill(255, 0 ,0);
    else
      fill(0, 0, 255);
    ellipse(x, y, radius * 2, radius * 2);
  }
  
  public float distance(float x_, float y_){
    return(sqrt(pow(x - x_, 2) + pow(y - y_, 2)));
  }
  
  public void drag(){
    if (down == true && mousePressed){
      move(mouseX - offset.x, mouseY - offset.y);
      moved = true;
    } else {
      down = false;
    }
  }
  
  public void doubleClicked(){
    if (distance(mouseX, mouseY) < radius) {
      coulomb *= -1;
      moved = true;
    }
  }
  
  public void mousePress(){
    if (distance(mouseX, mouseY) < radius && !down){
      offset = new PVector(mouseX - x, mouseY - y);
      down = true;
    }
  }
  
}
class EField extends CField{
  CField[] charge_fields;
  int charges_limit;
  int num_charges;
  
  EField(int width_, int height_, int scale_, int charges_limit_){
    super(width_, height_, scale_, new Charge(0,0,0));
    num_charges = 0;
    charges_limit = charges_limit_;
    charge_fields = new CField[charges_limit];
  }
  
  public void addCField(CField charge_field_){
    if (num_charges < charges_limit) {
      charge_fields[num_charges] = charge_field_;
      num_charges += 1;
    }
  }
  
  public void addCFields(CField[] charge_fields_){
    assert (charge_fields.length <= charges_limit - num_charges);
    for (CField field : charge_fields_){
      addCField(field);
    }
  }
  
  public @Override
  void update(){
    for (int c = 0; c < num_charges; c++){
      charge_fields[c].update();
    }
  }
  
  public void superposition(){
    field[ndx].scale(0);
    divergence[ndx] = 0;
    for (CField cfield: charge_fields){
      field[ndx].add(cfield.field[ndx]);
      divergence[ndx] += cfield.divergence[ndx];
    }
  }
  
  //void superposition(){
  //  int[] charges = new int[num_charges];
  //  int k = 0;
  //  for (int c = 0; c < num_charges; c++){
  //    if (Float.compare(charge_fields[c].divergence[ndx], charge_fields[c].mdivergence[ndx]) != 0){ 
  //      charges[k] = c;
  //      k++;
  //    }
  //  }
    
  //  for(int c = 0; c < k; c++){
  //    num_calls++;
  //    field[ndx].sub(charge_fields[charges[c]].mfield[ndx]);
  //    field[ndx].add(charge_fields[charges[c]].field[ndx]);
  //    divergence[ndx] -= charge_fields[charges[c]].mdivergence[ndx];
  //    divergence[ndx] += charge_fields[charges[c]].divergence[ndx];
  //  }
    
  //  if (k > 0) scaleV();
  //  println(num_calls + ": ");
    
  //}
  
  public void display(){
    for (i = 0; i <= width_/scale; i++){
      for (j = 0; j <= height_/scale; j++){
        ndx();
        superposition();
        divColor();
        scaleV();
        displayV();
      }
    }
    for (CField cfield: charge_fields){
      cfield.set();
      cfield.charge.display();
    }
  }
}
class FieldLine{
  PVector v0;
  PVector v;
  
  
  FieldLine(float x_, float y_){
    v0 = new PVector(x_, y_);
  }
  
  public float p(PVector v){
    return 8.9875517923f * pow(10, 9) * -2 * v.x/pow(v.x*v.x+v.y*v.y, 2);
  }
  
  public float q(PVector v){
    return 8.9875517923f * pow(10, 9) * -2 * v.y/pow(v.x*v.x+v.y*v.y, 2);
  }
}
class PVector {
  float x;
  float y;
  
  PVector(float x_, float y_){
    x = x_;
    y = y_;
  }
  
  public void limit(float max){
    if (mag() > max){
      normalize();
      scale(max);
    }
  }
  
  public void add(PVector v) {
    x = x + v.x;
    y = y + v.y;
  }
  
  public void sub(PVector v) {
    x = x - v.x;
    y = y - v.y;
  }
  
  public void scale(float c){
    x = x * c;
    y = y * c;
  }
  
  public void divide(float c){
    x = x/c;
    y = y/c;
  }
  
  public float divergence(){
    return x + y;
  }
  
  public float slope(){
    return y/x;
  }
  
  public float mag(){
    return sqrt(x*x + y*y);
  }
  
  public void normalize() {
    float m = mag();
    if (m != 0)
      scale(1/m);
  }
  
  public void setMag(float mag){ 
    normalize();
    scale(mag);
  }
  
  public float dot(PVector v) {
    return x * v.x + y * v.y;
  }
  
  public PVector mouse(){
    return new PVector(mouseX, mouseY);
  }
 
  public PVector get(){
    return this;
  }
  
  public void display(float x_, float y_){
    line(x_, y_, x_ + x, y_ - y);
  }
  
  public void display(float x_, float y_, boolean arrow){
    float mag = 0.3f/sqrt(2);
    if (arrow){
      line(x_ - x/2, y_ + y/2, x_ + x/2, y_ - y/2);
      line(x_ + x/2, y_ - y/2, x_ + x/2 + (-x + y) * mag, y_ - y/2 + (x + y) * mag);
      line(x_ + x/2, y_ - y/2, x_ + x/2 - (x + y) * mag, y_ - y/2 - (x - y) * mag);
      
      //line(x_ + x/2, y_ - y/2, x_ + x/2 + (x + y) * mag, y_ - y/2 - (y - x) * mag);
      //line(x_ + x/2, y_ - y/2, x_ + x/2 - (y - x) * mag, y_ - y/2 - (y + x) * mag);
    }
  }
}
class VField {
  int width_;
  int height_;
  int scale;
  PVector[] field;
  
  int ndx;
  int i;
  int j;
  
  VField(int _width_, int _height_, int scale_){
    width_ = _width_;
    height_ = _height_;
    scale = scale_;
    field = new PVector[(width_/scale + 1) * (height_/scale + 1)];
    for (i = 0; i <= width_/scale; i++){
      for (j = 0; j <= height_/scale; j++){
        ndx();
        field[ndx] = new PVector(0, 0);
      }
    }
  }
  
  public void ndx(){
    ndx = i * (width_/scale + 1) + j;;
  }
  
  public void displayV(){
    field[ndx].display(i * scale + (width_ % scale) / 2, j * scale + (height_ % scale) / 2, true);
  }
  
  public PVector get(int ndx){
    return field[ndx];
  }
}
  public void settings() {  size(1000, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "coulomb_field" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
