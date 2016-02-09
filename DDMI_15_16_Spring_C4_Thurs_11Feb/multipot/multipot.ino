int p1 = 0;
int p2 = 1;

void setup(){
  Serial.begin(9600);
}
void loop(){
  int v1 = analogRead(p1);
  int v2 = analogRead(p2);
  Serial.print("pot0:");
  Serial.println(v1);
  Serial.print("pot1:");
  Serial.println(v2);
  delay(15);
}
