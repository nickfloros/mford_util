part of anemometer_model;
/*
 * holds anemometer site details
 */
class AnemometerSite {
  int id;
  
  String stationName;
  String stationCode;
  
  double latitude;
  double longitude;

  AnemometerSite() ;
  
  factory AnemometerSite.create(int id, String name, String code, double latitude, double longitude){
    var value = new AnemometerSite()
     ..id=id
     ..stationName = name
     ..stationCode = code
     ..latitude = latitude
     ..longitude = longitude;
    
    return value;
  }
}
