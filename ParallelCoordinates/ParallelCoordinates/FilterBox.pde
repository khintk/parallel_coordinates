class FilterBox{
  float xPos;
  float yPos;
  float boxWidth;
  float boxHeight;
  
  FilterBox(){
    boxWidth = 30;
  }
  
  void display(float aX){
    noFill();
    strokeWeight(3);
    stroke(255,162,33);
    xPos = aX -12;
    rect(xPos, yPos, boxWidth, boxHeight);
  }
}