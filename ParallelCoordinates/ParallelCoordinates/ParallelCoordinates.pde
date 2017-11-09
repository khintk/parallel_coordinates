Table cameraTable;
Table carsTable;
Table dataset; 
Table datasetWithHeader;

//String filePathData = "cameras-cleaned.tsv";
String filePathData = "cars-cleaned.tsv";

int widthOfScreen = 1300;
int heigthOfScreen = 750;
Attribute[] attributes; 
Item[] items;

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
  dataset = loadTable(filePathData);
  datasetWithHeader = loadTable(filePathData,"header");
  attributes = new Attribute[dataset.getColumnCount()];
  items = new Item[datasetWithHeader.getRowCount()];
  //printArray(attributes);
  //attributes[0] = new Attribute(dataset.getString(0,0));
  // initialize array of items
  int count = 0;
  for (TableRow row : datasetWithHeader.rows()){
    items[count] = new Item(row.getString(0));
    count++;
  }
  
  float startingXValue = 50.0;
  int offset = widthOfScreen/ attributes.length;
  
  
  String[] nameOfColumns = new String[dataset.getColumnCount()];
  //String sample = dataset.getString(0,1);
  for (int i = 0; i < dataset.getColumnCount(); i ++){
    String name = dataset.getString(0,i);
    nameOfColumns[i] = name;
  }
  //printArray(nameOfColumns);

  //initialize attribute rectangles
  for(int i = 0; i<datasetWithHeader.getColumnCount(); i++){
    attributes[i] = new Attribute(startingXValue, 75.0, 5.0, 600.0, dataset.getString(0,i));
    startingXValue = startingXValue + offset;
  }
   
   //adding max and min for each attribute 
   for(int i = 0; i < nameOfColumns.length; i++){
    if(i == 0){
      attributes[i].max = items.length; // max is the number of items we have
      attributes[i].min = 0;
    }
    else{
      attributes[i].max = findMax(datasetWithHeader.getStringColumn(nameOfColumns[i]));
      attributes[i].min = findMin(datasetWithHeader.getStringColumn(nameOfColumns[i]));
    }
  }
  
  
  //Each item contains a value for each column 
  for (int i = 0; i< items.length; i++){ // each row
    for (int j = 1; j < attributes.length; j++){ // each column
      items[i].addEntry(attributes[j].label, datasetWithHeader.getFloat(i, j));
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

// right now this goes in the original order of the attribute columns

void drawLines(){
  strokeWeight(1);
  stroke(0,0,200);
  for (int i = 1; i < items.length; i++){
    noFill();
    beginShape();
    for (int j = 0; j < attributes.length; j++){
      Attribute currentAttribute = attributes[j];
      stroke(i*.25, i*.2, i*.5);
      float scaledY; 
      if (j == 0){ // the first attribute - items in the order they appear in the dataset
      //(need to check if current attribute type is string)
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