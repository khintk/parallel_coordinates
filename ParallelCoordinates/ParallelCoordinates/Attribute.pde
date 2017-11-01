class Attribute{
  float x;
  float y;
  float widthOfRectangle;
  float heightOfRectangle;
  boolean over = false;
  
  Attribute(float tempX1, float tempY1, float Width, float Height) {
    x = tempX1;
    y = tempY1;
    widthOfRectangle = Width;
    heightOfRectangle = Height;
  }
  
  void rollover(float px, float py) {
    //Write what happens if the mouse moves over. 
  }
  
  void display(){
    stroke(0);
    strokeWeight(0);
    fill(153);
    rect(x,y,widthOfRectangle,heightOfRectangle);
    if (over) {
       //Select the range of values, by drawing the rectangle bar over it. 
    }
  }
  
}