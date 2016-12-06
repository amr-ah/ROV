import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
import processing.serial.*;
import cc.arduino.*;
import org.firmata.*;
Arduino arduino;
ControlIO control;
Configuration config;
ControlDevice gpad;
//toggle read
float XL;
float YL;
float XR;
float YR;
float r;//left analog radious 
float v=0;// v is the ratio between both x and y in each quarter
//motors
float m1;float m2;
float m3;float m4;
float m1r;float m2r;
float m3r;float m4r;
float up; 
// all UI elements start from here

PShape m1A;
float Am1A=0;
PShape m2A;
PShape m3A;
PShape m4A;
PShape udA;

void setup() 
{
  size(700, 700);
  control = ControlIO.getInstance(this);
  gpad = control.getMatchedDevice("F310");
 // arduino = new Arduino(this,"COM3", 57600);
  if (gpad == null) {
    println("No suitable device configured");
    System.exit(-1);
  }
  //shapes decleration 
  rectMode(CENTER); 
   ellipseMode(CENTER);
 // m1A = createShape(RECT,0,0,(255*2)+2,20);
  /*m2A = createShape(ELLIPSE,350,250,(255*2)+2,20);
  m3A = createShape(ELLIPSE,350,300,(255*2)+2,20);
  m4A = createShape(ELLIPSE,350,350,(255*2)+2,20);
  udA = createShape(ELLIPSE,350,400,(255*2)+2,20);*/

}
         /*m1=0;m2=0;
         m3=0;m4=0;
         m1r=0;m2r=0;
         m3r=0;m4r=0;*/
  void draw() 
{
  background(255);
  //image(prop, 0, height/2, prop.width/2, prop.height/2);
  // all these values come between (-127.5_127.5);
   XL =gpad.getSlider("XL").getValue();
   YL =gpad.getSlider("YL").getValue();
   XR =gpad.getSlider("XR").getValue();
   YR =gpad.getSlider("YR").getValue();
   float ROT =gpad.getSlider("LT_RT").getValue();

    r = sqrt((XL*XL)+(YL*YL));
   //sometimes the radious is greater than 127
    if(abs(ROT)<5)
{
     if(r>127.5)
     {
       r=127.5;
     }
     if(r>6)
     {
       //first quarter
       if(XL>=0&&YL>0)
       {
         XL=abs(XL);
         YL=abs(YL);
         if(XL>=YL)
         {
           v=1-(YL/XL);
           m1=r*v;m1r=0;
           m2=r;m2r=0;
         }
         else if(XL<YL)
         {
          v=1-(XL/YL);
          m1=0;m1r=r*v;
          m2=r;m2r=0;
         }      
       }
       //second quarter
       if(XL<0&&YL>=0)
       {
         XL=abs(XL);
         YL=abs(YL);
         if(XL>=YL)
         {
           v=1-(YL/XL);
           m1=0;m1r=r;
           m2=0;m2r=r*v;
         }
         else if(XL<YL)
         {
           v=1-(XL/YL);
           m1=0;m1r=r;
           m2=r*v;m2r=0;
         }
       }
       //third quarter
       if(XL<=0&&YL<0)
       {
         XL=abs(XL);
         YL=abs(YL);
         if(XL>=YL)
         {
           v=1-(YL/XL);
           m1=0;m1r=r*v;
           m2=0;m2r=r;
         }
         else if(XL<YL)
         {
           v=1-(XL/YL);
           m1=r*v;m1r=0;
           m2=0;m2r=r;
         }
       }
       //forth quarter
       if(XL>0&&YL<=0)
       {
         XL=abs(XL);
         YL=abs(YL);
         if(XL>=YL)
         {
           v=1-(YL/XL);
           m1=r;m1r=0;
           m2=r*v;m2r=0;
         }
         else if(XL<YL)
         {
           v=1-(XL/YL);
           m1=r;m1r=0;
           m2=0;m2r=r*v;
         }
       }
       m3=m1;m3r=m1r;
       m4=m2;m4r=m2r;
     }
     else
    {
      XL=0;YL=0;v=0;
      m1=0;m2=0;
      m3=0;m4=0;
      m1r=0;m2r=0;
      m3r=0;m4r=0;
    }
  }
  else
  {
    //rotation code
      
      if(ROT<0)
      {
        m1=abs(ROT);
        m3r=abs(ROT);
        m1r=0;
        m3=0;
      }
      else
      {
        m1r=abs(ROT);
        m3=abs(ROT);
        m1=0;
        m3r=0;
      }
  }
  
   //code for up & down
    if(gpad.getButton("A").pressed()&&up<=250)
    {
      up+=5;
    }
    else if(gpad.getButton("X").pressed()&&up>=-250)
    {
      up-=5;
    }
   else if(up>0&&gpad.getButton("A").pressed()==false)
    {
      up-=5;
    }
    else if(up<0&&gpad.getButton("X").pressed()==false)
    {
      up+=5;
    }
    //up and down code 
    
    
    if(up>=0)
    {
      //arduino.analogWrite(2,int(up));
      //arduino.analogWrite(3,int(0));
      /*fill(255, 0, 0);
      ellipse(85, 200, (255/4)+up*1/4, (255/4)+up*1/4);
      fill(102, 102, 102);
      ellipse(85, 200, 255/4, 255/4);*/
      
      
    }
    if(up<0)
    {
      //arduino.analogWrite(3,int(-up));
      //arduino.analogWrite(2,int(0));
      /*fill(102, 102, 102);
      ellipse(85, 200, 255/4, 255/4);
      fill(255, 0, 0);
      ellipse(85, 200, (255/4)+up*1/4, (255/4)+up*1/4);
      */
    }
    //the arduino code 
    /*arduino.analogWrite(5,int(m1));
    arduino.analogWrite(4,int(m1r));
    arduino.analogWrite(7,int(m3));
    arduino.analogWrite(6,int(m3r));
   */
   //same H-bridge for m2 and m4
    //arduino.analogWrite(9,int(m2));
    //arduino.analogWrite(8,int(m2r));
    //arduino.analogWrite(9,int(m4));
    //.arduino.analogWrite(8,int(m4r));

  
  /*shape(m2A);
  shape(m3A);
  shape(m4A);
  shape(udA);*/
  draw_ROV(up);
  draw_motors();
  
  fill(255,0,0);
  text(mouseX+"  "+mouseY,mouseX,mouseY);
}


void draw_motors()
{
  /*rectMode(CORNERS);
  pushMatrix();
  stroke(0, 0, 0);
  strokeWeight(3);
  fill(2);
  rect(300,300,200,200);
  rotate(PIE/4);
  popMatrix();
*/
}

 void draw_ROV(float up)
 {
   //the ROV's body
   rectMode(CENTER);
  stroke(0, 0, 0);
  strokeWeight(3);
  fill(122,122,122);
  rect(350,350, 400, 500,8);
  //the up and down circles
  //up left motor
  text("up & down "+abs(int(up*100/255))+"%",60, 120);
  pushMatrix();
  fill(105,105,105);
  ellipse(85, 200, 255/2, 255/2);
  
  Am1A+=up*0.1/100;
  translate(85,200);
  fill(150);
  rotate(Am1A);
  ellipse(0, 0, 255/2, 20);
  popMatrix();
  
  fill(0);
  ellipse(85, 200, 40, 40);
  //down left motor
  fill(105,105,105);
  ellipse(85, 500, 255/2, 255/2);
  
  Am1A+=up*0.1/100;
  pushMatrix();
  translate(85, 500);
  fill(150);
  rotate(Am1A);
  ellipse(0, 0, 255/2, 20);
  popMatrix();
  
  fill(0);
  ellipse(85, 500, 40, 40);
  //down right motor
  fill(105,105,105);
  ellipse(616, 500, 255/2, 255/2);
  
  Am1A+=up*0.1/100;
  pushMatrix();
  translate(616, 500);
  fill(150);
  rotate(Am1A);
  ellipse(0, 0, 255/2, 20);
  popMatrix();
  
  fill(0);
  ellipse(616, 500, 40, 40);
  //up right motor
  fill(105,105,105);
  ellipse(616, 200, 255/2, 255/2);
  
  Am1A+=up*0.1/100;
  pushMatrix();
  translate(616, 200);
  fill(150);
  rotate(Am1A);
  ellipse(0, 0, 255/2, 20);
  popMatrix();
  
  fill(0);
  ellipse(616, 200, 40, 40);
 }