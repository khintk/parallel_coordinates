class Attribute{
  float x;
  float y;
  float widthOfRectangle;
  float heightOfRectangle;
  String label;
  float max;
  float min; 
  boolean isStringType;
  FilterBox box;
  
  
  Attribute(float tempX1, float tempY1, float Width, float Height, String labelString) {
    x = tempX1;
    y = tempY1;
    widthOfRectangle = Width;
    heightOfRectangle = Height;
    label = labelString;
    isStringType = false;
  }
  
  boolean inLBounds(float px, float py){ // check if click is valid to select attribute (in label bounds)
    if( px > (x - 15) && px < (x +15) && (py > (y-45)) && py < (y-15)){
      return true; 
    }
    return false;   
  }
  
  boolean inBBounds(float px, float py){ // check filter box
    if( px > x -12 && px < (x-12 +30) && (py > y) && py < (y + heightOfRectangle )){
      return true; 
    }
    return false; 
  }
  
  boolean shouldMoveBox(float px, float py){ // in upper bounds of box
    if( px >= box.xPos && px <= box.xPos+ box.boxWidth && (py > box.yPos -5) && py < (box.yPos+5)){
      return true; 
    }
    return false;  
  }
  boolean shouldResizeBox(float px, float py){
    if( px >= box.xPos && px <= box.xPos + box.boxWidth && (py > box.yPos + box.boxHeight -5) && py < (box.yPos + box.boxHeight+5)){
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
    
    if (box != null){
      box.display(x);
    }
  }
  
}