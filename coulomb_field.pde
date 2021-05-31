EField efield;
CField[] cfields;
int scale = 10; //resolution of vector field, smaller is more computationally intensive
int num_charges =  100; //number of charges in field
int zoom = 10;

int num_calls = 0;

void setup() {
  size(1000, 1000);
  cfields = new CField[num_charges];
  for (int c = 0; c < num_charges; c++)
    cfields[c] = new CField(width, height, scale, new Charge(random(width/10, width * 9/10), random(height/10, height * 9/10), randCharge()));
  efield = new EField(width, height, scale, num_charges);
  efield.addCFields(cfields);
}

void draw() {
  //noLoop();
  clear();
  background(0);
  stroke(255,0,0);
  strokeWeight(2);
  
  //draws field
  efield.update();
  efield.display();
  
  //debugging commentry
  println(frameRate);
  //println(num_calls);
}

//initiates a random charge
int randCharge(){
  return (-1 + (int)random(2) * 2);
}

//toggle for dragging after single click
void mousePressed(){
  for (int c = 0; c < num_charges; c++) cfields[c].charge.mousePress();
}

//toggle for double click
public void mouseClicked(MouseEvent evt) {
  if (evt.getCount()%2 == 0) for (int c = 0; c < num_charges; c++) cfields[c].charge.doubleClicked();
}
