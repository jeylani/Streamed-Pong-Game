import websockets.*;

import processing.serial.*;
import cc.arduino.*;

WebsocketClient wsc;
Arduino arduino;
//Serial myPort;  // Create object from Serial class$
int sensorPin=0;
float paddle_x=100, paddle_y=378;
float balle_x=100, balle_y=10;
float speed_x = 10, speed_y = 10;
boolean balle_paddle_collision = false;
float value;
int score;

PFont f; 
public String message="score : 0";
void setup() 
{
  wsc= new WebsocketClient(this, "ws://localhost:1337");
  frameRate(10);
  size(400,400); //make our canvas 200 x 200 pixels big
   //String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
   //myPort = new Serial(this, portName, 9600);
 arduino=new Arduino(this,Arduino.list()[0],57600);
  arduino.pinMode(sensorPin,Arduino.INPUT);
  f = createFont("Georgia",16,true); // STEP 2 Create Font
}

void draw() {
 value = arduino.analogRead(sensorPin);
 //println(value);
 background(0, 255, 0);
  color(0,0,255);
  textFont(f,80);// STEP 3 Specify font to be used 
  fill(0,0,255);   // STEP 4 Specify font color
  textSize(20);
  text(message,(width-380),height-380);   // STEP 5 Display Text
  
 paddle_x = map(value, 30, 645, 0, 320);
 //paddle_x = mouseX;
 
 color(255);
 
 if(paddle_x>320)
   paddle_x = 320;
 else if(paddle_x < 0)
   paddle_x = 0;
 
 if(balle_x <= 10){
   speed_x = 10;
 }else if(balle_x >= 390){
   speed_x = -10;
 }
 
 if(balle_y <= 10){
   speed_y = 10;
   
 }else if(balle_y >= 390 || (balle_x - paddle_x)<=80 && (paddle_y - balle_y) <= 10 && !balle_paddle_collision){
   speed_y = -10;
   balle_paddle_collision = true;
   score+=1;
   message ="score :"+score;
   if(balle_y == 390){
       fill(255);   // STEP 4 Specify font color
        textSize(60);
        message ="you lose";
        score=0;
        text(message,(width/2),height/2);   // STEP 5 Display Text
        
        delay(2000);
         message ="score : 0";
   }
 }else{
   balle_paddle_collision = false;
 }
 
 
 balle_x += speed_x;
 balle_y += speed_y;
 fill(255,0,0);
 ellipse(balle_x,balle_y,20,20);
 fill(255);
 rect(paddle_x, paddle_y, 80, 20);
 String str = ""+paddle_x+","+balle_x+","+balle_y;
 wsc.sendMessage(str);

}

void webSocketEvent(String msg){
 println(msg);
}
