import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class DetalleAnuncioPage extends StatelessWidget {
  const DetalleAnuncioPage();

  @override
  Widget build(BuildContext context) {
    final RemoteMessage? message = ModalRoute.of(context)!.settings.arguments as RemoteMessage?;
    return Scaffold(
      appBar: AppBar(
        title: Text('${message!.notification!.title}'),
      ),
      body: Container(
        child: Text(message.notification!.body as String),
      ),
    );
  }
}