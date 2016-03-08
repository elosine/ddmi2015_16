//pot
int np = 2; //number of pots
int p[] = { A0, A2 }; //analog input pins
int pv[2];//pot value
int ppv[] = {0, 0}; //previous pot value

//buttons
int nb = 2;
int b[] = { 2, 3 }; //digital input pins
boolean bg[] = {true, true};//momentary button gates
////button toggle
int btv[] = { 0, 0 }; //toggle button current value
int btamt[] = { 2, 7 }; //number of toggles
boolean btg[] = {true, true};//toggle button gates

void setup() {
  Serial.begin(9600);
  //sets the digital pins for the buttons to input and pulls resistor high
  for (int i = 0; i < nb; i++) {
    pinMode(b[i], INPUT_PULLUP);
  } //end for (int i = 0; i < nb; i++) loop thru all buttons
} //end setup


void loop() {

  //POTS
  for (int i = 0; i < np; i++) { //loop thru all pots
    pv[i] = analogRead(p[i]); //read analog pin
    //Send out values only when pot changes
    if ( pv[i] < (ppv[i] - 1) || pv[i] > (ppv[i] + 1) ) {
      //Action
        Serial.print( "p" + String(i) + ":");
      Serial.println(pv[i]); //send value to serial bus
    }
    //Update previous value
    ppv[i] = pv[i];


  }//end loop thru all pots


  //BUTTONS

  for (int i = 0; i < nb; i++) { //loop thru all buttons

    //if button is pressed (reads LOW)
    if ( digitalRead(b[i]) == LOW ) { //button on

      ////Momentary
      if (bg[i]) {
        bg[i] = false;
        Serial.print( "b" + String(i) + ":");
        Serial.println(1);
      }

      ////Toggles
      if (btg[i]) {
        btg[i] = false; //CLOSE GATE
        btv[i] = btv[i] + 1; //INC VALUE
        btv[i] = btv[i] % btamt[i]; //MOD VALUE
        Serial.print( "bt" + String(i) + ":"); //PRINT HEADER
        Serial.println(btv[i]); //PRINT VAL
      }

    } //end if button pressed

    //if button is released (reads HIGH)
    if ( digitalRead(b[i]) == HIGH ) { //button off

      ////Momentary
      if (!bg[i]) {
        bg[i] = true;
        Serial.print( "b" + String(i) + ":");
        Serial.println(0);
      }

      ////Toggles
      if (!btg[i]) {
        btg[i] = true;
      }

    } //end if button released


  } //end loop all buttons


} //end void loop

//BUTTONS2
if ( digitalRead(b0) == LOW ) { //button on

  ////Toggle0
  if (btg0) {
    btg0 = false; //CLOSE GATE
    btv0 = btv0 + 1; //INC VALUE
    btv0 = btv0 % btamt0; //MOD VALUE
    Serial.print("bt0:"); //PRINT HEADER
    Serial.println(btv0); //PRINT VAL
  }

  ////Momentary
  if (bg0) {
    bg0 = false;
    Serial.print("b0:");
    Serial.println(1);
  }
}

if ( digitalRead(b0) == HIGH ) { //button released

  ////Toggle
  if (!btg0) {
    btg0 = true;
  }

  ////Momentary
  if (!bg0) {
    bg0 = true;
    Serial.print("b0:");
    Serial.println(0);
  }
}


//BUTTONS1
if ( digitalRead(b1) == LOW ) {
  ////Toggle1
  if (btg1) {
    btg1 = false;
    btv1 = btv1 + 1;
    btv1 = btv1 % btamt1;
    Serial.print("bt1:");
    Serial.println(btv1);
  }

  ////Momentary
  if (bg1) {
    bg1 = false;
    Serial.print("b1:");
    Serial.println(1);
  }
}

if ( digitalRead(b1) == HIGH ) { //button released


  ////Toggle
  if (!btg1) {
    btg1 = true;
  }

  ////Momentary
  if (!bg1) {
    bg1 = true;
    Serial.print("b1:");
    Serial.println(0);
  }
}


//POTS
//Pot 0
v0 = analogRead(p0); //read analog pin
//Send out values only when pot changes
if ( v0 < (pv0 - 1) || v0 > (pv0 + 1) ) {
  //Action
  Serial.print("pot0:"); //string header
  Serial.println(v0); //send value to serial bus
}
//Update previous value
pv0 = v0;

//Pot 1
v1 = analogRead(p1); //read analog pin
if ( v1 < (pv1 - 1) || v1 > (pv1 + 1) ) {
  Serial.print("pot1:"); //string header
  Serial.println(v1); //send value to serial bus
}
pv1 = v1;

////Delay
delay(15);
}
