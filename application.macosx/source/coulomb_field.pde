EField efield;
CField[] chargeFields;
int scale = 40; //resolution of vector field
int num_charges =  10;

int num_calls = 0;

void setup() {
  size(1000, 1000);
  chargeFields = new CField[num_charges];
  for (int c = 0; c < num_charges; c++)
    chargeFields[c] = new CField(width, height, scale, new Charge(random(width/10, width * 9/10), random(height/10, height * 9/10), randCharge()));
  efield = new EField(width, height, scale, num_charges);
  efield.addCFields(chargeFields);
}

void draw() {
  //noLoop();
  clear();
  background(0);
  stroke(255,0,0);
  strokeWeight(2);
  
  efield.update();
  efield.display();
  
  //println(frameRate);
}

int randCharge(){
  return (-1 + (int)random(2) * 2);
}

void mousePressed(){
  for (int c = 0; c < num_charges; c++)
    chargeFields[c].charge.mousePress();

}

public void mouseClicked(MouseEvent evt) {
  if (evt.getCount()%2 == 0)
    for (int c = 0; c < num_charges; c++)
      chargeFields[c].charge.doubleClicked();
}
