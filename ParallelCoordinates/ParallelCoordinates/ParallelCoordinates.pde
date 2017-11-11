//Authors: Brighten Jelke and Khin Kyaw
// Program that reads a table of data and visualizes it using a parallel coordinate system.

Table cameraTable;
Table carsTable;
Table dataset; 

// COMMENT OUT THE FILEPATH AS NECESSARY

//String filePath = "cameras-cleaned.tsv";
String filePath = "cars-cleaned.tsv";
//String filePath = "nutrients-cleaned.tsv";

ArrayList<Attribute> attributes; // each column in the table is an attribute
Item[] items; // each row in the table is an item
Attribute selectedAttribute;
FilterBox selectedBox;

int selectedIndex; // index of currently selected attribute, meant to minimize arraylist lookups
boolean resizeBox; // if filter box is being resized
boolean moveBox; // if filter box is being moved

boolean showMarks; // if marks are shown
// Right now, only the minimum and maximum of float-type attributes are displayed,
// but future implementations would show string names and tick marks

void setup() {
  size(1300, 750, P2D);
  pixelDensity(displayDensity());
  loadData();
  
  resizeBox = false;
  moveBox = false;
  showMarks = false;
}

void draw() {
  background(255);
  processItems();
  drawLines();
   for(int i = 0; i<attributes.size(); i++){
     attributes.get(i).display();
     if (showMarks){
       attributes.get(i).showMarks();
     }
  }
  text(filePath, width/2 - 50, 5);
}

void loadData() {
  dataset = loadTable(filePath,"header");
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
    
    // check attribute data type
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
  
  //Each item contains a value for each attribute
  // fill hashmaps of these values
  for (int i = 0; i< items.length; i++){ // each row
    for (int j = 0; j < attributes.size(); j++){ // each column
      if (!attributes.get(j).isStringType){
        items[i].addEntry(attributes.get(j).label, dataset.getFloat(i, j));
      }
    }
  }
}

void mousePressed(){
  // check every attribute to see if it has been clicked on
  for (int i = 0; i < attributes.size(); i++){
    Attribute c = attributes.get(i);
    // handle rearrangement of axes
    if(c.inLBounds(mouseX, mouseY)){
      selectedAttribute = c;
      selectedIndex = i;
      break; // optimization: if one label is clicked, don't check the rest
    } // handle filtering
    else if(c.inBBounds(mouseX, mouseY)){
      if (c.box == null){ // no selection box exists
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
  if (selectedAttribute != null){ // reordering
    selectedAttribute.x = mouseX;
  }
  else if (selectedBox != null){ // filtering
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
  }
  selectedBox = null;
  resizeBox = false;
  moveBox = false;
}

 // m key determines whether or not extra marks should be shown
 public void keyPressed(){
   if (key == 'm'){
     showMarks = showMarks == false ? true : false;
   }
 }

// Given an input value, calculate its placement on the attribute bar
// return the y coordinate of the point on the screen
float scalePoint(float max, float min, float point){
  float yStartPoint = 75;
  float heightOfBar = 600;
  float interval = heightOfBar/ (max-min);
  float positionOnBar = ((max - point) * interval) + yStartPoint;
  return positionOnBar;
}

// Find the maximum value in a given column
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

// Find the minimum value in a given column
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


// draw lines representing the values for each item
void drawLines(){
  strokeWeight(0.7);
  
  for (int i = 0; i < items.length; i++){
    stroke(16, 81, 15);
    noFill();
    Item currentItem = items[i];
    if (!currentItem.shouldShow){ // if filter is on, color gray and partially transparent
     stroke(200, 150);
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
      vertex(currentAttribute.x, scaledY); // shape (line) is drawn from one vertex to the next
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

  // determine if the item line should be filtered or not
 void processItems(){
   // there is a lot of duplicated code here from the drawLines() method. Future implementations would minimize this. 
   // optimizations could include saving the scaledY into a data structure.
  for (int i = 1; i < items.length; i++){
    Item currentItem = items[i];
    int j = 0;
    while (j < attributes.size()){
      Attribute currentAttribute = attributes.get(j);
      if (currentAttribute.box != null){ // if a filter exists on this attribute
        float scaledY; 
        // calculate y position of value
        if (currentAttribute.isStringType){
          scaledY = scalePoint(currentAttribute.max, currentAttribute.min, i);
        }
        else{ 
          scaledY = scalePoint(currentAttribute.max, currentAttribute.min, items[i].getValue(currentAttribute.label));
        }
        
        // check if that y position is within the filter box bounds
        if (!currentAttribute.withinFilter(scaledY)){
          currentItem.shouldShow = false;
          break; // if one value is outside, the whole line will be gray
        }
        else{
          currentItem.shouldShow = true;
        }
      }
      j++;
    }
  }
 }
