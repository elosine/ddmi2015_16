//pot
int p0 = A0;
int p1 = A2;
int v0, pv0, v1, pv1;
//buttons
int b0 = 2;
boolean bg0 = true;
////button toggle
int btv = 0;
int btamt = 2;
boolean btg = true;

void setup() {
  Serial.begin(9600);
  pinMode(b0, INPUT_PULLUP);
}
void loop() {
  //BUTTONS
  ////Toggle

  if ( digitalRead(b0) == LOW ) {
    ////Toggle
    if (btg) {
      btg = false;
      btv = btv + 1;
      btv = btv%btamt;
      Serial.print("bt:");
      Serial.println(btv);
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
    if (!btg) {
      btg = true;
    }
    ////Momentary
    if (!bg0) {
      bg0 = true;
      Serial.print("b0:");
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
