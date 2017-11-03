
class Item{
  
  String name;
  // need generic type to handle strings and ints??
  //HashMap<String, int> dataPoints; // maps attribute to the value, so Item that is a car
  // will have entries <"name", "buick skylark">, <"mpg", 320>, <"horsepower", 350>, etc.
  // needs to be an arraylist i think
  
  Item(String n){
    name = n;
  }
  
  String toString(){
    return name;
  }
  
}