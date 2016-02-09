int pin = 0;

void setup(){
  Serial.begin(9600);
}
void loop(){
  int val = analogRead(pin);
  Serial.print("pot0:");
  Serial.println(val);
  delay(200);
}
