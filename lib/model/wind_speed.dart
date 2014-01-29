part of anemometer_model;
/**
 * wind speed
 */

class WindSpeed {
  double min, max, avg;
  
  WindSpeed() {
    
  }
  
  factory WindSpeed.create(Map jsonMap) {
    var value = new WindSpeed()
      ..min = jsonMap['min']
      ..max = jsonMap['max']
      ..avg = jsonMap['avg'];   
    return value;
  }

  /*
   * map object to a list
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