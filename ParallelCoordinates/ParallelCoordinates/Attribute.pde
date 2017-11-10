class Attribute{
  float x;
  float y;
  float widthOfRectangle;
  float heightOfRectangle;
  String label;
  float max;
  float min; 
  boolean isStringType;
  
  
  Attribute(float tempX1, float tempY1, float Width, float Height, String labelString) {
    x = tempX1;
    y = tempY1;
    widthOfRectangle = Width;
    heightOfRectangle = Height;
    label = labelString;
    isStringType = false;
  }
  
  boolean inBounds(float px, float py){ // check if click is valid to select attribute
    if( px > (x - 15) && px < (x +15) && (py > (y-45)) && py < (y-15)){
      return true; 
    }
    return false;   
  }
  
  
  void display(){
    stroke(0);
    strokeWeight(0);
    fill(50);
    rect(x,y,widthOfRectangle,heightOfRectangle);
    textAlign(LEFT,TOP);
    text(label,x-15,y-30);
    textSize(10);
  }
  
}