
public class Led {
  
  int x;
  int y;
  int diam;
  color ledColor;
  boolean clicked;
  int i;
  
  public Led (int xp, int yp) {
    x = xp;
    y = yp;
    diam = 15;
    ledColor = 0;
    clicked = false;
    i = 0;
  }
  
  void display() {
    fill(ledColor);
    stroke(0);
    if(clicked) {
      stroke(255);
    }
    ellipseMode(CORNER);
    ellipse(x, y, diam, diam);
  }
  
  boolean over() {
    if(mouseX >= x && mouseX <= x + diam 
      && mouseY >= y && mouseY <= y + diam) {
      return true;
    }
    else {
      return false;
    }
  }
  
  void clicked() {
    clicked =! clicked;
  }
  
  void setColor(color col) {
    ledColor = col;
  }
  
  int getRed() {
    return (int) red(ledColor);
  }
  
  int getGreen() {
    return (int) green(ledColor);
  }
  
  int getBlue() {
    return (int) blue(ledColor);
  }
  
  void setRed(int r) {
    ledColor &= 0xFFFF;
    ledColor |= (r << 16);
  }
  
  void setGreen(int g) {
    ledColor &= 0xFF00FF;
    ledColor |= (g << 8);
  }

  void setBlue(int b) {
    ledColor &= 0xFFFF00;
    ledColor |= b;
  }
}
