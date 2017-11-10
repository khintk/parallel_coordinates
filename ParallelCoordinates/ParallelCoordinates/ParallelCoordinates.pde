Table cameraTable;
Table carsTable;
Table dataset; 

//String filePathData = "cameras-cleaned.tsv";
String filePathData = "cars-cleaned.tsv";
//String filePathData = "nutrients-cleaned.tsv";

ArrayList<Attribute> attributes; 
Item[] items;
Attribute selectedAttribute;

void setup() {
  size(1300, 750, P2D);
  pixelDensity(displayDensity());
  loadData();
}

void draw() {
  background(255);
   for(int i = 0; i<attributes.size(); i++){
     attributes.get(i).display();
  }
  drawLines();
}

void loadData() {
  dataset = loadTable(filePathData,"header");
  attributes = new ArrayList<Attribute>(dataset.getColumnCount());
  items = new Item[dataset.getRowCount()];
  
  // initialize array of items
  int count = 0;
  for (TableRow row : dataset.rows()){
    items[count] = new Item(row.getString(0));
    count++;
  }
  
  float startingXValue = 50.0;
  int offset = width/ dataset.getColumnCount();
  

  //initialize attribute rectangles
  for(int i = 0; i<dataset.getColumnCount(); i++){
    String title = dataset.getRow(0).getColumnTitle(i);
    Attribute newA = new Attribute(startingXValue, 75.0, 5.0, 600.0, title);
    startingXValue = startingXValue + offset;
    
    String testStr = dataset.getString(0, i); 
    try {
     float testVal = Float.valueOf(testStr);
    } 
    catch (NumberFormatException e) {
      newA.isStringType = true;
    }
    //add max and min for each attribute 
    if(newA.isStringType){
      newA.max = items.length; // max is the number of items we have
      newA.min = 0;
    }
    else{
      newA.max = findMax(dataset.getStringColumn(title));
      newA.min = findMin(dataset.getStringColumn(title));
    }
     attributes.add(i,newA);
    
  }  
  //Each item contains a value for each column
  // fill hashmaps of these values
  for (int i = 0; i< items.length; i++){ // each row
    for (int j = 0; j < attributes.size(); j++){ // each column
      if (!attributes.get(j).isStringType){
        items[i].addEntry(attributes.get(j).label, dataset.getFloat(i, j));
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

int selectedIndex;
void mousePressed(){
  for (int i = 0; i < attributes.size(); i++){
    if(attributes.get(i).inBounds(mouseX, mouseY)){
      selectedAttribute = attributes.get(i);
      selectedIndex = i;
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
    swap(selectedAttribute, selectedIndex);
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
    for (int j = 0; j < attributes.size(); j++){
      Attribute currentAttribute = attributes.get(j);
      stroke(i*.25, i*.2, i*.5);
     // stroke(150, 40, 230);
      float scaledY; 
      if (currentAttribute.isStringType){ // if it's a string, just place based on index
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

//handle reordering of axes
void swap(Attribute a, int indexOfA){
 boolean done = false;
 // if the attribute has been moved left
 for (int i = 0; i < indexOfA; i++){
   if (a.x < attributes.get(i).x){
     attributes.remove(a);
     attributes.add(i, a);
     done = true;
     break;
   }
 }
 // if it has been moved to the right
 if (!done){
   for (int j = attributes.size()-1; j > indexOfA; j--){
     if (a.x > attributes.get(j).x){
       attributes.remove(indexOfA);
       attributes.add(j, a);
       break;
     }
   }
 }
}