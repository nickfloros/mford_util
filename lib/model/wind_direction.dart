part of anemometer_model;
/**
 * defines wind direction parameters
 */
class WindDirection {
  
  int min, max, avg;
  
  WindDirection() {
    
  }
  
  factory WindDirection.create(Map jsonMap) {
    var value = new WindDirection()
    ..min = jsonMap['min']
    ..max = jsonMap['max']
    ..avg = jsonMap['avg'];        
    
    return value;
  }
  
  /*
   * map object to list 
   */
  List toList(var xAxisValue) {
    var list= new List()
      ..add(xAxisValue)
      ..add(min)
      ..add(avg)
      ..add(max);
      
    return list;
  }
}
