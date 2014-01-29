
/**
 * utility class to hold map marker callback referrence ... this is too convoluted there must be a better way 
 */
class MarkerCallback {
  int _ref;
  Function _callBack;
  String _desc;

  /**
   * 
   */
  MarkerCallback(this._callBack, this._desc, this._ref); 
  
  /*
   * call back from JS universe
   */
  void onClick(var misc) {
    print('selected ${_ref}');
    _callBack(_ref);
  }
}
