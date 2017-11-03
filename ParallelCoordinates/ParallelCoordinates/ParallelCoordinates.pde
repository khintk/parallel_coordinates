Table cameraTable;
Table carsTable;
Table dataset; 
String filePathData = "cameras-cleaned.tsv";
int widthOfScreen = 800;
int heigthOfScreen = 600;
Attribute[] attributes; 

void setup() {
  size(1000, 700);
  pixelDensity(displayDensity());
  loadData();
}

void draw() {
  background(255);
   for(int i = 0; i<attributes.length; i++){
     attributes[i].display();
  
  }
  printArray(attributes);
}

void loadData() {

  //cameraTable = loadTable("cameras-cleaned.tsv", "header");
  //carsTable =  loadTable("cars-cleaned.tsv", "header");
  dataset = loadTable(filePathData, "header");
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
  
  float startingXValue = 25.0;
  int offset = 900/ attributes.length;
  
  //initialize attribute rectangles
  for(int i = 0; i<dataset.getColumnCount(); i++){
    attributes[i] = new Attribute(startingXValue, 975.0, 5.0, 5.0);
    startingXValue = startingXValue + offset;
  }
  
  
  
  for (Item i : items){
    System.out.println(i.toString());
  }
  
  
  //bubbles = new Bubble[table.getRowCount()];


  //for (int i = 0; i<table.getRowCount(); i++) {
  //  // Iterate over all the rows in a table.
  //  TableRow row = table.getRow(i);  
  //  // Access the fields via their column name (or index).
  //  float x = row.getFloat("x");
  //  float y = row.getFloat("y");
  //  float d = row.getFloat("diameter");
  //  String n = row.getString("name");
  //  // Make a Bubble object out of the data from each row.
  //  bubbles[i] = new Bubble(x, y, d, n);
}