import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tabasco_escapes/preferences/preferences.dart';

class NotificationServices {

final _firebaseNotificationInstance = FirebaseMessaging.instance;
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> processNotification(RemoteMessage message) async {
  print("*************************************************************");
  print("Ttitle ${message.notification?.title}");
  print("Body ${message.notification?.body}");
  print("Paylod ${message.data}");
  print("*************************************************************");
  
}

void handleMessage(RemoteMessage? message){
  if(message==null) return ;

  navigatorKey.currentState?.pushNamed("detalleAnuncio", arguments: message);
}

Future<void> initNotifications () async {
  await _firebaseNotificationInstance.requestPermission();
  final _token = await _firebaseNotificationInstance.getToken();
  Preferences.tokenNotification = _token!;
  print(_token);
  FirebaseMessaging.onBackgroundMessage(processNotification);
  initPushNotifications();
}

Future<void> initPushNotifications ()async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen( handleMessage );
}

}