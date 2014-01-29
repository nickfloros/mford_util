part of anemometer_model;
/**
 * representation of an anemoeter reading 
 */
class AnemometerReading {
  int id;
  DateTime timeStamp;
  WindDirection direction;
  WindSpeed speed;
  
  AnemometerReading() {}

  /**
   * parser 
   */
  factory AnemometerReading.parse(Map jsonMap) {
    var value = new AnemometerReading()
      ..id = jsonMap['id']
      ..timeStamp = DateTime.parse(jsonMap['timeStamp'])
      ..direction = new WindDirection.create(jsonMap['direction'])
      ..speed = new WindSpeed.create(jsonMap['speed']);
    
    return value;
  }
}
