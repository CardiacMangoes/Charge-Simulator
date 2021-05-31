class EField extends CField{
  CField[] charge_fields;
  int charges_limit;
  int num_charges;
  
  boolean moved;
  
  EField(int width_, int height_, int scale_, int charges_limit_){
    super(width_, height_, scale_, new Charge(0,0,0));
    num_charges = 0;
    charges_limit = charges_limit_;
    charge_fields = new CField[charges_limit];
  }
  
  void addCField(CField charge_field_){
    if (num_charges < charges_limit) {
      charge_fields[num_charges] = charge_field_;
      num_charges += 1;
    }
  }
  
  void addCFields(CField[] charge_fields_){
    assert (charge_fields.length <= charges_limit - num_charges);
    for (CField field : charge_fields_){
      addCField(field);
    }
  }
  
  @Override
  void update(){
    for (int c = 0; c < num_charges; c++){
      charge_fields[c].update();
    }
  }
  
   /*
    new superposition function
  */
  void superposition(){
    boolean moved = false;
    for (int c = 0; c < num_charges; c++){
      if (charge_fields[c].charge.moved) moved = true;
    }    
    if (moved){
      field[ndx].scale(0);
      divergence[ndx] = 0;
      for (CField cfield: charge_fields){
        field[ndx].add(cfield.field[ndx]);
        divergence[ndx] += cfield.divergence[ndx];
          num_calls++;
      }
    }
  }
  
  /*
    old superposition function
  */
  //void superposition(){
  //  int[] charges = new int[num_charges];
  //  int k = 0;
  //  for (int c = 0; c < num_charges; c++){
  //    if (charge_fields[c].charge.moved){
  //      moved = true;
  //      charges[k] = c;
  //      k++;
  //    }
  //  }
    
  //  for(int c = 0; c < k; c++){
  //    field[ndx].sub(charge_fields[charges[c]].mfield[ndx]);
  //    field[ndx].add(charge_fields[charges[c]].field[ndx]);
  //    divergence[ndx] -= charge_fields[charges[c]].mdivergence[ndx];
  //    divergence[ndx] += charge_fields[charges[c]].divergence[ndx];
  //    num_calls++;
  //  }
  //}
  
  void display(){
    for (i = 0; i <= width_/scale; i++){
      for (j = 0; j <= height_/scale; j++){
        ndx();
        superposition();
        divColor();
        displayV();
      }
    }
    for (CField cfield: charge_fields) cfield.charge.display();
  }
}
