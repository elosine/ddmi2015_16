int p0 = A0;
int p1 = A2;
int v0, pv0, v1, pv1;

void setup() {
  Serial.begin(9600);
}
void loop() {
  //Pot 0
  v0 = analogRead(p0); //read analog pin
  //Send out values only when pot changes
  if ( v0 < (pv0-1) || v0 > (pv0+1) ) {
    //Action
    Serial.print("pot0:"); //string header
    Serial.println(v0); //send value to serial bus
  }
  //Update previous value
  pv0 = v0;

  //Pot 1
  v1 = analogRead(p1); //read analog pin
  if ( v1 < (pv1-1) || v1 > (pv1+1) ) {
  Serial.print("pot1:"); //string header
  Serial.println(v1); //send value to serial bus
  }
  pv1 = v1;

  ////Delay
  delay(15);
}
