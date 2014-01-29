library modal_loading;
import 'dart:html';
import 'package:polymer/polymer.dart';

/**
 * Modal loading custom element based on Bootstrap 
 */
@CustomTag('modal-loading')
class ModalLoading extends PolymerElement {
 
  bool applyAuthorStyles = true;
  @published String titleText="";
  @published bool fadeBackdrop=true;
  DivElement _modalBackdrop ;
  
  ModalLoading.created() : super.created() {
    _modalBackdrop = new DivElement();
    _modalBackdrop.classes.addAll(["modal-backdrop","fade","in"]);
  }

  void enteredView() {
    super.enteredView();
  }
  
  void show({String titleTxt: null}) {
    
    $['myModal'].hidden=false;
    $['myModal'].classes.toggle('in');
    $['myModal'].attributes['aria-hidden']='true';
    $['myModal'].style.display='block';

    if (titleTxt!=null) {
      titleText = titleTxt;
      print('modal.show : $titleText');
      $['myModalLabel'].text=titleText;
    }
    if (fadeBackdrop)
      ownerDocument.documentElement.children.add(_modalBackdrop);
  }
  
  void onClose() {
    hide();
  }
  
  void onSave() {
    hide();
  }
  
  void hide() {
    $['myModal'].classes.toggle('in');
    $['myModal'].attributes['aria-hidden']='false';
    $['myModal'].style.display='none';
    $['myModal'].hidden=true;

    if (fadeBackdrop)
      ownerDocument.documentElement.children.removeLast();
  }
}

