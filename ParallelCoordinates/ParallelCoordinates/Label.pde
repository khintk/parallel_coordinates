class Label{
  //String labeltxt;
  String lable;
  float x;
  float y;
  
  Label(String num, float xvalue, float yvalue){
    lable = num;
    x  = xvalue;
    y  = yvalue;
    
  }
  void display(){
    textSize(8);
    fill(20,20,20);
    text(lable, x, y);
  }
}