library nav_bar;
import 'dart:html';
import 'package:polymer/polymer.dart';

/**
 * Navigation bar custom element based on Bootstrap 
 */
@CustomTag('nav-bar')
class NavBar extends PolymerElement {
  // need that to ensure that bootscrap css is applied
  bool get applyAuthorStyles => true;
  
  // list of items to display
  @published 
  List options = toObservable([]);

  // event to generate when an option is selected ..
  static final String selectionEventName='navTabEvent';
  
  static final String mapSelected = 'mapSelected';
  
  // remembers which item is curently selected
  var _currentSelected; 
  
  NavBar.created() : super.created() {
    print('NavBar.created : shadowRoot is null ${shadowRoot==null}');
  }
  
  void enteredView() {
    super.enteredView();
    print('NavBar.enteredView : shadowRoot is null ${shadowRoot==null}');
    
  }

  void _toggleNavBar() {
    if (_navBarActive!=null){
      _navBarActive.classes.toggle('collapse');
      _navBarActive.classes.toggle('collapsing');
    }
  }
  
  void onSelected(Event e, var detail, Element target) {
    var idStr = target.getAttribute('data-value');
    if (idStr!=null) {
      _toggle(target.parent);      
      _toggleNavBar();
      _navBarActive=null;
      
      this.fire(selectionEventName,detail:int.parse(idStr));
    }
    
  }
  
  Element _navBarActive=null;
  
  void showNavBar() {
    _navBarActive = shadowRoot.getElementById('navContent');
    _navBarActive.style.height="auto";
    _toggleNavBar();
  }

  void select(String id){
    var elem = shadowRoot.getElementById('li${id}');
    if (elem!=null)  {
      _toggle(elem);
    }
  }
  
  void onMapSelected(Event e, var details, Element target) {
    _toggle(target.parent);
    var navBar = shadowRoot.getElementById('navContent');
    _toggleNavBar();
    _navBarActive=null;
    this.fire(mapSelected);
  }
  
  void _toggle(Element target) {
    if (_currentSelected!=null)
      _currentSelected.classes.toggle('active');
    // this is because the action is on the anchor element but the style applies to the parent div
    _currentSelected = target; 
    _currentSelected.classes.toggle('active');
  }
  
  void setSites(var sites){
    options.addAll(sites);
  }
    
  /*
   * again hardwired .. 
   */
  int get height {
    if ($['footDiv']!=null)
      return $['headerDiv'].clientHeight;  
    return 50;
    }
}

