library mford_gmap;
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:google_maps/google_maps.dart';
import 'package:logging/logging.dart' show Logger, Level, LogRecord;

import 'map_marker_callback.dart';
/**
 * Google map element based on google_maps package
 */
@CustomTag('mford-map')
class MfordGoogleMap extends PolymerElement {
  final Logger _log = new Logger('MfordGoogleMap');

  bool get applyAuthorStyles => true;
  /**
   * inital center of map latittude ..
   */
  @published num cLat=52.3;
  /*
   * inital center of map longtude
   */
  @published num cLng=-1.1;

  static const String MARKER_SELECTED_EVENT = "markerSelected";
  
  var mapOptions;
  var _mapCanvas;
  GMap _map;
  
  var _latLngBound;
  Map _markers = new Map();

  MfordGoogleMap.created() : super.created() {
    _log.fine('MfordMap.created : shadowRoot is null ${shadowRoot==null}');
  }

  void enteredView() {
    super.enteredView();
    _init();
  }
  
  /**
   * init map 
   */
  void _init() {
    if (_map==null) {
      _mapCanvas = $['map_canvas'];
      mapOptions = new MapOptions()
      ..zoom = 8
      ..center = new LatLng(cLat,cLng)
      ..mapTypeId = MapTypeId.ROADMAP
      ;

      _map = new GMap(_mapCanvas, mapOptions);

      _log.fine('GMap.enteredView : shadowRoot is null ${shadowRoot==null}');
      _latLngBound = new LatLngBounds();
      
    }
  }
  
  void _resize(int width, int height) {
    if (_mapCanvas!=null) {
    _mapCanvas.style.width='${width}px';
    _mapCanvas.style.height='${height}px';
    }
  }
  
  void show(int width,int height) {
    _log.fine('resize : [${width},${height}');
    _resize(width,height);
    _map.fitBounds(_latLngBound);
  }
  
  /**
   * add a marker 
   */
  void addMarker(String key, String desc, num lat, num lng){

    
    if(_map!=null) {
      _latLngBound.extend(new LatLng(lat, lng));
      
      var mOptions = new MarkerOptions()
      ..position = new LatLng(lat, lng)
      ..map = _map
      ..title = desc
      ..clickable = true;
      _markers[key]=mOptions;
     MarkerCallback mCallBack = new MarkerCallback(notify, desc, _markers.length-1);
     var m = new Marker(mOptions);
     m.onClick.listen(mCallBack.onClick);
     
    }
    else
      _log.fine('Gmap.addMarker _map is null');
  }

  /*
   * fire event identifying that an marker was selected
   */
  void notify(int markerId){
    this.fire(MfordGoogleMap.MARKER_SELECTED_EVENT,detail:markerId);
  }
  
}

