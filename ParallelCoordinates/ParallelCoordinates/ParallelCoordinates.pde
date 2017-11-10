Table cameraTable;
Table carsTable;
Table dataset; 

//String filePathData = "cameras-cleaned.tsv";
//String filePathData = "cars-cleaned.tsv";
String filePathData = "nutrients-cleaned.tsv";

int widthOfScreen = 1300;
int heigthOfScreen = 750;
Attribute[] attributes; 
Item[] items;
Attribute selectedAttribute;

void setup() {
  size(1300, 750);
  pixelDensity(displayDensity());
  loadData();
}

void draw() {
  background(255);
   for(int i = 0; i<attributes.length; i++){
     attributes[i].display();
  }
  drawLines();
}

void loadData() {
  dataset = loadTable(filePathData,"header");
  attributes = new Attribute[dataset.getColumnCount()];
  items = new Item[dataset.getRowCount()];
  
  // initialize array of items
  int count = 0;
  for (TableRow row : dataset.rows()){
    items[count] = new Item(row.getString(0));
    count++;
  }
  
  float startingXValue = 50.0;
  int offset = widthOfScreen/ attributes.length;
  

  //initialize attribute rectangles
  for(int i = 0; i<dataset.getColumnCount(); i++){
    String title = dataset.getRow(0).getColumnTitle(i);
    attributes[i] = new Attribute(startingXValue, 75.0, 5.0, 600.0, title);
    startingXValue = startingXValue + offset;
    
    String testStr = dataset.getString(0, i); 
    try {
     float testVal = Float.valueOf(testStr);
    } 
    catch (NumberFormatException e) {
      attributes[i].isStringType = true;
    }
    //add max and min for each attribute 
    if(attributes[i].isStringType){
      attributes[i].max = items.length; // max is the number of items we have
      attributes[i].min = 0;
    }
    else{
      attributes[i].max = findMax(dataset.getStringColumn(title));
      attributes[i].min = findMin(dataset.getStringColumn(title));
    }
    
  }  
  //Each item contains a value for each column
  // fill hashmaps of these values
  for (int i = 0; i< items.length; i++){ // each row
    for (int j = 0; j < attributes.length; j++){ // each column
      if (!attributes[j].isStringType){
        items[i].addEntry(attributes[j].label, dataset.getFloat(i, j));
      }
    }
  }

}

float scalePoint(float max, float min, float point){
  float yStartPoint = 75;
  //float yEndPoint = 675;
  float heightOfBar = 600;
  float interval = heightOfBar/ (max-min);
  float positionOnBar = ((max - point) * interval) + yStartPoint;
  return positionOnBar; // this represents the y coordinate on the screen
}

float findMax(String[] valuesInColumns) { 
  float maxValue = 0.0;
  for (int i = 0; i < valuesInColumns.length; i++) {
    float value = Float.valueOf(valuesInColumns[i]);
    if (value > maxValue){
      maxValue = value;
    }
  }
  return maxValue;
}

float findMin(String[] valuesInColumns) { 
  float minValue = Float.MAX_VALUE;
  for (int i = 0; i < valuesInColumns.length; i++) {
    float value = Float.valueOf(valuesInColumns[i]);
    if (value < minValue){
      minValue = value;
    }
  }
  return minValue;
}
 
void mousePressed(){
  for (int i = 0; i < attributes.length; i++){
    if(attributes[i].inBounds(mouseX, mouseY)){
      selectedAttribute = attributes[i];
    } 
  }
}

void mouseDragged(){
  if (selectedAttribute != null){
    selectedAttribute.x = mouseX;
  }
}

void mouseReleased(){
  if (selectedAttribute != null){
    selectedAttribute.x = mouseX;
    selectedAttribute = null;
  }
}
// right now this goes in the original order of the attribute columns

void drawLines(){
  strokeWeight(0.7);
  stroke(0,0,200);
  for (int i = 1; i < items.length; i++){
    noFill();
    beginShape();
    for (int j = 0; j < attributes.length; j++){
      Attribute currentAttribute = attributes[j];
      //stroke(i*.25, i*.2, i*.5);
      stroke(150, 40, 230);
      float scaledY; 
      if (currentAttribute.isStringType){ // the first attribute - items in the order they appear in the dataset
      //(need to check if current attribute type is string)
        // use arrayList to store attributes
        scaledY = scalePoint(currentAttribute.max, currentAttribute.min, i);
      }
      else{ // names have been taken care of, so draw lines to previous 
        scaledY = scalePoint(currentAttribute.max, currentAttribute.min, items[i].getValue(currentAttribute.label));
      }
      vertex(currentAttribute.x, scaledY);
    }
    endShape();
  }
}