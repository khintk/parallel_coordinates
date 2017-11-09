class Attribute{
  float x;
  float y;
  float widthOfRectangle;
  float heightOfRectangle;
  boolean over = false;
  String label;
  float max;
  float min; 
  
  
  Attribute(float tempX1, float tempY1, float Width, float Height, String labelString) {
    x = tempX1;
    y = tempY1;
    widthOfRectangle = Width;
    heightOfRectangle = Height;
    label = labelString;
  }
  
  
  
  boolean isSelected(float px){
    if( px > (x - 15) && px < (x + 15)){
      return true; 
    }
    return false; 
    
  }
  
   void isReleased(float px){
     x = px;
    
  }
  
  
  void display(){
    stroke(0);
    strokeWeight(0);
    fill(50);
    rect(x,y,widthOfRectangle,heightOfRectangle);
    textAlign(LEFT,TOP);
    text(label,x-15,y-30);
    textSize(10);
    
    if (over) {
       //Select the range of values, by drawing the rectangle bar over it. 
    }
  }
  
}