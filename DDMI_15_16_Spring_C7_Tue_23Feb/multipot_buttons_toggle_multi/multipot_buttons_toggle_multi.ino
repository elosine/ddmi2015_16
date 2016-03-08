//pot
int p0 = A0;
int p1 = A2;
int v0, pv0, v1, pv1;
//buttons
int b0 = 2;
int b1 = 3;
boolean bg0 = true;
boolean bg1 = true;
////button toggle
int btv0 = 0;
int btamt0 = 5;
boolean btg0 = true;

int btv1 = 0;
int btamt1 = 2;
boolean btg1 = true;

void setup() {
  Serial.begin(9600);
  pinMode(b0, INPUT_PULLUP);
  pinMode(b1, INPUT_PULLUP);
}
void loop() {
  
  //BUTTONS2
  if ( digitalRead(b0) == LOW ) { //button on
    
    ////Toggle0
    if (btg0) {
      btg0 = false; //CLOSE GATE
      btv0 = btv0 + 1; //INC VALUE
      btv0 = btv0%btamt0; //MOD VALUE
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
      btv1 = btv1%btamt1;
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
