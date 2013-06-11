/*
Jenna deBoisblanc
5/11/13
jdeboi.com

This Processing sketch is designed to send serial 
color data an Arduino with LEDs connected to a TLC5940 
chip. The color picker and sliders change the color of
a selected dot. 
Pressing the 's' key sends the RGB data to the Arduino.
*/

import processing.serial.*;
Serial myPort;
// array of values to be sent serially
int [] gsData = new int[16];

// LEDs
int numLeds = 5;
Led[] leds = new Led[numLeds];

// color picker and color sliders
ColorPicker cp;
HScrollbar hs1, hs2, hs3;

// position variables
int windowWidth = 600;
int windowHeight = 600;
int xOffset = 30;
int yOffset = 100;
int xSpacing = (windowWidth - (2 * xOffset))/numLeds;
int ledDim = 20;

// selected LED data
boolean selected = false;
int clickedLed;
color selectedColor;
int selectedColorR;
int selectedColorG;
int selectedColorB;


/////////////////////////////////////////////////////////////
//SETUP//////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void setup() {
  size(windowWidth, windowHeight);
  cp = new ColorPicker(100, 150, 300, 200, 255);
  initLeds();
  initScrollbars();
  
  // List all the available serial ports:
  println(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[4], 57600);
}

/////////////////////////////////////////////////////////////
//DRAW///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void draw() {
  background(120);
  cp.render();
  cp.update();
  drawLeds();
  updateSliders();
  updateSelected();
}

void drawLeds() {
  for(int i = 0; i < numLeds; i++) {
    leds[i].display();
  }
}

/////////////////////////////////////////////////////////////
//INPUT//////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void mousePressed() {
  updateLeds();
}


void keyPressed() {
  if (key == 's') {
    sendGSData();
  }
}

/////////////////////////////////////////////////////////////
//INITIALIZE/////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void initLeds() {
  for(int i = 0; i < numLeds; i++) {
    leds[i] = new Led((int) (xOffset + (i+.5) * xSpacing), yOffset);
  }
}

void initScrollbars() {
  hs1 = new HScrollbar(width/2, 400, width/3, 16, 16);
  hs2 = new HScrollbar(width/2, 450, width/3, 16, 16);
  hs3 = new HScrollbar(width/2, 500, width/3, 16, 16);
}

/////////////////////////////////////////////////////////////
//SET////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void setGSData() {
  for(int i = 0; i < numLeds; i++) {
    gsData[i * 3] = leds[i].getRed();
    gsData[(i * 3) + 1] = leds[i].getGreen();
    gsData[(i * 3) + 2] = leds[i].getBlue();
  }
}

void sendGSData() {
  setGSData();
  for (int i = 0; i < gsData.length; i++) {
    myPort.write(gsData[i]);
  }
}

void setSliders(color col) {
  hs1.setColorPos(col >> 16 & 0xFF);
  hs2.setColorPos(col >> 8 & 0xFF);
  hs3.setColorPos(col & 0xFF);
}

void clearSelected() {
  for (int i = 0; i < numLeds; i++) {
    leds[i].clicked = false;
  }
}

/////////////////////////////////////////////////////////////
//UPDATE/////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
void updateLeds() {
  for(int i = 0; i < numLeds; i++) {
    if(leds[i].over()) {
      leds[i].clicked();
      if(!leds[i].clicked) {
        selected = false;
      }
      else {
        selected = true;
        clickedLed = i;
        clearSelected();
        leds[i].clicked = true;
        selectedColor = leds[i].ledColor;
        setSliders(selectedColor);
      }
    }
  }
}

void updateSelected() {
  if (selected) {
    selectedColor = color(selectedColorR, selectedColorG, selectedColorB);
    leds[clickedLed].setColor(selectedColor);
  }
}

void updateSliders() {
  hs1.update();
  hs2.update();
  hs3.update();
  selectedColorR = (int) hs1.getNormalized();
  selectedColorG = (int) hs2.getNormalized();
  selectedColorB = (int) hs3.getNormalized();
  hs1.display();
  hs2.display();
  hs3.display();
}
