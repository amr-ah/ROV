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
float up; float down;
// all UI elements start from here
PShape m1A;
PShape m1B;

PShape m2A;
PShape m2B;

PShape m3A;
PShape m3B;

PShape m4A;
PShape m4B;

PShape udA;
PShape udB;


void setup() 
{
  size(700, 700);
  control = ControlIO.getInstance(this);
  gpad = control.getMatchedDevice("F310");
  arduino = new Arduino(this,"COM3", 57600);
  if (gpad == null) {
    println("No suitable device configured");
    System.exit(-1);
  }
  //shapes decleration 
  rectMode(CENTER); 
  m1A = createShape(RECT,350,200,(255*2)+2,20);
  m1B = createShape(RECT,350,200,10,24);
 
  m2A = createShape(RECT,350,250,(255*2)+2,20);
  m2B = createShape(RECT,350,250,10,24);
 
  m3A = createShape(RECT,350,300,(255*2)+2,20);
  m3B = createShape(RECT,350,300,10,24);
 
  m4A = createShape(RECT,350,350,(255*2)+2,20);
  m4B = createShape(RECT,350,350,10,24);
  
  udA = createShape(RECT,350,400,(255*2)+2,20);
  udB = createShape(RECT,350,400,10,24);
}

         /*m1=0;m2=0;
         m3=0;m4=0;
         m1r=0;m2r=0;
         m3r=0;m4r=0;*/
  void draw() 
{
  background(0, 0, 0);
  
  // all these values come between (-127.5_127.5);
   XL =gpad.getSlider("XL").getValue();
   YL =gpad.getSlider("YL").getValue();
   XR =gpad.getSlider("XR").getValue();
   YR =gpad.getSlider("YR").getValue();
   float ROT =gpad.getSlider("LT_RT").getValue();
      text("rotation  "+ ROT,328,485);
   
   
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
   else if(up>0)
    {
      up-=5;
    }
    else if(up<0)
    {
      up+=5;
    }
    //up and down code 
    if(up>=0)
    {
      arduino.analogWrite(2,int(up));
      arduino.analogWrite(3,int(0));
      
      
    }
    if(up<0)
    {
      arduino.analogWrite(3,int(-up));
      arduino.analogWrite(2,int(0));
    }
    //the arduino code 
    arduino.analogWrite(5,int(m1));
    arduino.analogWrite(4,int(m1r));
    arduino.analogWrite(7,int(m3));
    arduino.analogWrite(6,int(m3r));
   
   //same H-bridge for m2 and m4
    //arduino.analogWrite(9,int(m2));
    //arduino.analogWrite(8,int(m2r));
    //arduino.analogWrite(9,int(m4));
    //.arduino.analogWrite(8,int(m4r));
    
    
    
    
    
    //actual drawing starts from here
   
   text("XL =" +XL,328,35);
   text("YL =" +YL,328,45);
   text("XR =" +XR,328,55);
   text("YR =" +YR,328,65);
   text("v= "+v ,328,85);
   text("r =" +r,328,75);
   
   text("m1 =" +m1,228,95);text("m1r =" +m1r,398,95);
   text("m2 =" +m2,228,105);text("m2r =" +m2r,398,105);
   text("m3 =" +m3,228,115);text("m3r =" +m3r,398,115);
   text("m4 =" +m4,228,125);text("m4r =" +m4r,398,125);
   
   //motor 1
    text("m1",328,185);
   m1A.setFill(color(255,0,0)); m1A.setStroke(color(0)); m1A.setStrokeWeight(1);
   m1B.setFill(color(255)); m1B.setStroke(color(0)); m1B.setStrokeWeight(1);
   //motor 2
    text("m2",328,235);
   m2A.setFill(color(255,0,0));m2A.setStroke(color(0));m2A.setStrokeWeight(1);
   m2B.setFill(color(255));m2B.setStroke(color(0));m2B.setStrokeWeight(1);
   //motor 3
   text("m3",328,285);
   m3A.setFill(color(255,0,0));m3A.setStroke(color(0));m3A.setStrokeWeight(1);
   m3B.setFill(color(255));m3B.setStroke(color(0));m3B.setStrokeWeight(1);
   //motor 4
   text("m4",328,335);
   m4A.setFill(color(255,0,0));m4A.setStroke(color(0));m4A.setStrokeWeight(1);
   m4B.setFill(color(255));m4B.setStroke(color(0));m4B.setStrokeWeight(1);
   //up&down
   text("up & down"+ up +"   "+ down,328,385);
   m4A.setFill(color(255,0,0));m4A.setStroke(color(0));m4A.setStrokeWeight(1);
   m4B.setFill(color(255));m4B.setStroke(color(0));m4B.setStrokeWeight(1);
   
   
   if(m1>0)
    {
      m1B.translate(m1*2, 0);
    }
    else if(m1r>0)
    {
      m1B.translate(-m1r*2, 0);
    }
    
    if(m2>0)
    {
      m2B.translate(m2*2, 0);
    }
    else if(m2r>0)
    {
      m2B.translate(-m2r*2, 0);
    }
    
    if(m3>0)
    {
        m3B.translate(m3*2, 0);
    }
    else if(m3r>0)
    {
      m3B.translate(-m3r*2, 0);
    }
    
    if(m4>0)
    {
      m4B.translate(m4*2, 0);
    }
    else if(m4r>0)
    {
      m4B.translate(-m4r*2, 0);
    }
    
  shape(m1A);
  shape(m1B);
  shape(m2A);
  shape(m2B);
  shape(m3A);
  shape(m3B);
  shape(m4A);
  shape(m4B);
  shape(udA);
  shape(udB);
  
  m1B.resetMatrix();
  m2B.resetMatrix();
  m3B.resetMatrix();
  m4B.resetMatrix();
  udB.resetMatrix();
  delay(50);
     
  
}
 