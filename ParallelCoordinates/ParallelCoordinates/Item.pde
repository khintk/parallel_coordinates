
class Item{
  
  String name;
  boolean shouldShow;
  HashMap<String, Float> dataPoints; // maps attribute to the value, so Item that is a car
  // will have entries <"name", "buick skylark">, <"mpg", 320>, <"horsepower", 350>, etc.

  Item(String n){
    name = n;
    dataPoints = new HashMap<String,Float>();
    shouldShow = true;
  }
  
  void addEntry(String attribute, float value){
    dataPoints.put(attribute, value);
  }
  
  float getValue(String k){
    return dataPoints.get(k);
  }
  
  String toString(){
    return name;
  }
  
}