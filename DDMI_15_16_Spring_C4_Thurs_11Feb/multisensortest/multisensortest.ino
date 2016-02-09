int p1 = A0;
int p2 = A1;

int b1 = 3;
int b1t = 0;
int b1g = true;
int b1tg = true;

int b2 = 7;
int b2t = 0;
int b2g = true;
int b2tg = true;


void setup(){
  Serial.begin(9600);
  pinMode(b1, INPUT_PULLUP);
}
void loop(){
  //POTS
  int v1 = analogRead(p1);
  int v2 = analogRead(p2);
  //Serial.print("pot0:");
 // Serial.println(v1);
 // Serial.print("pot1:");
  //Serial.println(v2);
  //BUTTONS
  
  ////b1////
  //////Momentary
  if(b1g){
    if( digitalRead(b1) == LOW ){ // if button A is pressed
      b1g = false;
    //  Serial.print("b0:");
    //  Serial.println(1);
    }
  }
  //////if button is released
  if(!b1g){
    if(digitalRead(b1) == HIGH){
      b1g = true;
      Serial.print("b0:");
      Serial.println(0);
    }
  }
  //////Toggle
  if(b1tg){
    if( digitalRead(b1) == LOW ){ // if button A is pressed
      b1tg = false;
      b1t = (b1t+1)%2;
      Serial.print("bt0:");
      Serial.println(b1t);
    }
  }
  //////if button is released
  if(!b1tg){
    if(digitalRead(b1) == HIGH){
      b1tg = true;
    }
  }
  
  ////b2////
  //////Momentary
  if(b2g){
    if( digitalRead(b2) == LOW ){ // if button A is pressed
      b2g = false;
      //Serial.print("b1:");
      //Serial.println(1);
    }
  }
  //////if button is released
  if(!b2g){
    if(digitalRead(b2) == HIGH){
      b2g = true;
     // Serial.print("b1:");
     // Serial.println(0);
    }
  }
  //////Toggle
  if(b2tg){
    if( digitalRead(b2) == LOW ){ // if button A is pressed
      b2tg = false;
      b2t = (b2t+1)%2;
      Serial.print("bt1:");
      Serial.println(b2t);
    }
  }
  //////if button is released
  if(!b2tg){
    if(digitalRead(b2) == HIGH){
      b2tg = true;
    }
  }
  delay(30);
}
