library mford_gae;
import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'anemometer_model.dart';
export 'anemometer_model.dart';
import 'package:lawndart/lawndart.dart';

/**
 * Google App Engine mobile end points
 * They serve weather data 
 */
class Mford_Gae_Services {
  var _url = 'https://mford-gae.appspot.com/_ah/api/wsep/v1';
  
  List<AnemometerSite> sites = new List<AnemometerSite>();
  Store _dbStore = new Store('dwStore', 'sitesStore');
  
  Mford_Gae_Services(){
  }
  
  Future<List<AnemometerSite>> readSites() {
    Completer comp = new Completer<List<AnemometerSite>>();
    _dbStore.open().then((_) {
      _dbStore.getByKey('sites').then( (String rawData) {
          if (rawData!=null) {
            comp.complete(_parseSites(rawData));
          }
          else {
            HttpRequest.getString('$_url/sites')
              .then((result) { 
                _dbStore.save(result,'sites').then( (_)  {
                  comp.complete(_parseSites(result));                  
                });
              })
              .catchError((onError) {
                comp.completeError('error');
              });
          }
        });
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

    _dbStore.open().then( (_) {
      var siteCode = sites[id].stationCode;
      _dbStore.getByKey(siteCode).then( (String rawData) {
         ;
        if (rawData != null) {
          AnemometerSiteReadings resp = _parseReading(rawData);
          if (resp.expireTime.isAfter(new DateTime.now())) {
            return comp.complete(resp);
          }
        }
        HttpRequest.getString('$_url/report?site=$siteCode')
          .then((result) { 
            _dbStore.save(result,siteCode ).then((_){
              AnemometerSiteReadings resp = _parseReading(result);
              comp.complete(resp);
            });
          })
            .catchError((onError) {
              comp.completeError('error');
            });
        
      });
    });
    

    return comp.future;
  }
  
  
  AnemometerSiteReadings _parseReading(String rawData) {
    AnemometerSiteReadings resp = new AnemometerSiteReadings();
    resp.lastRead = new DateTime.now();

    var map = JSON.decode(rawData);
    resp.readings = new List<AnemometerReading>();
    if (map['status']['success']) {
      for (var reading in map['readings']) {
        resp.readings.add(new AnemometerReading.parse(reading));
      }
    }
    resp.expireTime = resp.readings.last.timeStamp.add(new Duration(minutes: 10));
    return resp;   
  }
}

