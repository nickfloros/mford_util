library mford_gae;
import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'anemometer_model.dart';
export 'anemometer_model.dart';

/**
 * Google App Engine mobile end points
 * They serve weather data 
 */
class Mford_Gae_Services {
  var _url = 'https://mford-gae.appspot.com/_ah/api/wsep/v1';
  
  List<AnemometerSite> sites = new List<AnemometerSite>();
  
  Mford_Gae_Services(){
    
  }
  
  Future<List<AnemometerSite>> readSites() {
    Completer comp = new Completer<List<AnemometerSite>>();
    HttpRequest.getString('$_url/sites')
      .then((result) { 
        comp.complete(_parseSites(result));
        })
      .catchError((onError) {
        comp.completeError('error');
        });

    return comp.future;
  }

  /*
   * parse sites response 
   */
  List<AnemometerSite> _parseSites(var payload) {
    
    var map = JSON.decode(payload);
    if (map['status']['success'] == true) {
      sites.clear(); // make sure the list of sites is empty
      for (var item in map['sites']) {
        var s = new AnemometerSite.create(item['id'], 
            item['name'], 
            item['code'],
            item['lattitude'],
            item['longitude']);
        sites.add(s);
      }
    }
    return sites;
  }
  
  /*
   * read site weather info
   */
  Future<AnemometerSiteReadings> readSite(int id) {
    
    Completer comp = new Completer<AnemometerSiteReadings>();
    
    HttpRequest.getString('$_url/report?site=${sites[id].stationCode}')
      .then((result) { 
        AnemometerSiteReadings resp = new AnemometerSiteReadings();
        resp.lastRead = new DateTime.now();

        var map = JSON.decode(result);
        resp.readings = new List<AnemometerReading>();
        if (map['status']['success']) {
          for (var reading in map['readings']) {
            resp.readings.add(new AnemometerReading.parse(reading));
          }
        }
        resp.expireTime = resp.readings.last.timeStamp.add(new Duration(minutes: 10));
        comp.complete(resp);
        })
      .catchError((onError) {
        comp.completeError('error');
        });

    return comp.future;
  }
}

