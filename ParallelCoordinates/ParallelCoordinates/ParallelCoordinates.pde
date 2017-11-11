Table cameraTable;
Table carsTable;
Table dataset; 

//String filePathData = "cameras-cleaned.tsv";
String filePathData = "cars-cleaned.tsv";
//String filePathData = "nutrients-cleaned.tsv";

ArrayList<Attribute> attributes; 
Item[] items;
Attribute selectedAttribute;
FilterBox selectedBox;

int selectedIndex;
boolean resizeBox;
boolean moveBox;

void setup() {
  size(1300, 750, P2D);
  pixelDensity(displayDensity());
  loadData();
  
  resizeBox = false;
  moveBox = false;
}

void draw() {
  background(255);
  drawLines();
   for(int i = 0; i<attributes.size(); i++){
     attributes.get(i).display();
  }
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
    //if (count % 4 == 0){
    //  items[count-1].shouldShow = false;
    //}
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


void mousePressed(){
  for (int i = 0; i < attributes.size(); i++){
    Attribute c = attributes.get(i);
    if(c.inLBounds(mouseX, mouseY)){
      selectedAttribute = c;
      selectedIndex = i;
    } // CHECK IF IN ATTRIBUTE BOUNDS
    else if(c.inBBounds(mouseX, mouseY)){
      if (c.box == null){ // first box
        FilterBox b = new FilterBox();
        b.boxHeight = 20;
        b.yPos = mouseY;
        c.box = b;
      }
      selectedBox = c.box;
      if (c.shouldResizeBox(mouseX, mouseY)){
         resizeBox = true;
      }
      else if (c.shouldMoveBox(mouseX, mouseY)){
         moveBox = true;
      }
      
    }
  }
}

void mouseDragged(){
  if (selectedAttribute != null){
    selectedAttribute.x = mouseX;
  }
  else if (selectedBox != null){
    if (moveBox){
      if (mouseY > 75 && mouseY + selectedBox.boxHeight < 675){
        selectedBox.yPos = mouseY;
      }
    }
    else if (resizeBox){
      if (mouseY > (selectedBox.yPos +5) && mouseY < 675){
        selectedBox.boxHeight = mouseY - selectedBox.yPos;
      }
    }
  }
}

void mouseReleased(){
  if (selectedAttribute != null){
    selectedAttribute.x = mouseX;
    swap(selectedAttribute, selectedIndex);
    selectedAttribute = null;
    selectedBox = null;
    resizeBox = false;
    moveBox = false;
  }
}
// right now this goes in the original order of the attribute columns

void drawLines(){
  strokeWeight(0.7);
  for (int i = 1; i < items.length; i++){
    stroke(16, 81, 15);
    noFill();
    Item currentItem = items[i];
    if (!currentItem.shouldShow){ //choice here: either don't draw it or make it grayscale/transparent
      stroke(255,0,0);
    }
    beginShape();
    for (int j = 0; j < attributes.size(); j++){
      Attribute currentAttribute = attributes.get(j);
      float scaledY; 
      if (currentAttribute.isStringType){ // if it's a string, just place based on index
        scaledY = scalePoint(currentAttribute.max, currentAttribute.min, i);
      }
      else{ 
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