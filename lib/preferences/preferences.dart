

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static late SharedPreferences _prefs;

  static bool _isUpgraded = false;
  static String _nombreEmpresa = "";
  static String _tokenNotification = "";
  static String _logotipo = "https://media.istockphoto.com/id/1339046127/es/vector/dise%C3%B1o-de-logotipo-de-chispa-abstracto-simple-logotipo-de-estrella-de-geometr%C3%ADa-plana-en.jpg?s=612x612&w=0&k=20&c=dmOhK6AVCgtM64rPA_surB_KaanLnEmImUjkA759V-0=";

  static Future init()async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isUpgraded {
    return _prefs.getBool("isUpgraded") ?? _isUpgraded;
  }

  static set isUpgraded(bool upgraded) {
    _isUpgraded = upgraded;
    _prefs.setBool('isUpgraded', _isUpgraded); 
  }

  static String get nombreEmpresa {
    return _prefs.getString("nombreEmpresa") ?? _nombreEmpresa; 
  }

  static set nombreEmpresa(String value){
    _nombreEmpresa = value;
    _prefs.setString("nombreEmpresa", value);
  }

  static String get logotipo {
    return _prefs.getString("logotipo") ?? _logotipo;
  }

  static set logotipo(String value){
    _logotipo = value;
    _prefs.setString("logotipo", value);
  }

  static String get tokenNotification {
    return _prefs.getString("tokenNotification") ?? _tokenNotification;
  }

  static set tokenNotification(String value){
    _tokenNotification = value;
    _prefs.setString("tokenNotification", value);
  }
  
}