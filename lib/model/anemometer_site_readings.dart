part of anemometer_model;
/**
 * contains readings from a site
 */
class AnemometerSiteReadings {
  DateTime lastRead;
  DateTime expireTime;
  
  List<AnemometerReading> readings;
}
