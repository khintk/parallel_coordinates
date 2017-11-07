Table cameraTable;
Table carsTable;
Table dataset; 
Table datasetWithHeader;

String filePathData = "cameras-cleaned.tsv";
//String filePathData = "cars-cleaned.tsv";

int widthOfScreen = 1300;
int heigthOfScreen = 750;
Attribute[] attributes; 

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
}

void loadData() {
  dataset = loadTable(filePathData);
  attributes = new Attribute[dataset.getColumnCount()];
  Item[] items = new Item[dataset.getRowCount()];
  //printArray(attributes);
  //attributes[0] = new Attribute(dataset.getString(0,0));
  // initialize array of items
  int count = 0;
  for (TableRow row : dataset.rows()){
    items[count] = new Item(row.getString(0));
    count++;
  }
  
  float startingXValue = 50.0;
  int offset = widthOfScreen/ attributes.length;
  datasetWithHeader = loadTable(filePathData,"header");
  
  String[] nameOfColumns = new String[dataset.getColumnCount()];
  //String sample = dataset.getString(0,1);
  for (int i = 0; i < dataset.getColumnCount(); i ++){
    String name = dataset.getString(0,i);
    nameOfColumns[i] = name;
  }
  printArray(nameOfColumns);

  //initialize attribute rectangles
  for(int i = 0; i<datasetWithHeader.getColumnCount(); i++){
    attributes[i] = new Attribute(startingXValue, 75.0, 5.0, 600.0, dataset.getString(0,i));
    startingXValue = startingXValue + offset;
  }
   
   //adding max and min for each attribute 
   for(int i = 0; i < nameOfColumns.length; i++){
    if(i == 0){
      attributes[i].max = 0.0;
    }
    else{
      attributes[i].max = findMax(datasetWithHeader.getStringColumn(nameOfColumns[i]));
      attributes[i].min = findMin(datasetWithHeader.getStringColumn(nameOfColumns[i]));
    }
  }
  
  
  //Each item contains a value for each column 
  for (int i = 1; i< items.length; i++){ // each row
    for (int j = 1; j < attributes.length; j++){ // each column
      items[i].addEntry(attributes[j].label, dataset.getFloat(i, j));
    }
  }

}

float scalePoint(float max, float min, float point){
  float yStartPoint = 75;
  float yEndPoint = 675;
  float heighOfBar = 600;
  float interval = heighOfBar/ (max-min); 
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
  float minValue = 0.0;
  for (int i = 0; i < valuesInColumns.length; i++) {
    float value = Float.valueOf(valuesInColumns[i]);
    if (value > minValue){
      minValue = value;
    }
  }
  return minValue;
}