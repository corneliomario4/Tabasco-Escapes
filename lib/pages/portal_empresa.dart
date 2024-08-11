import 'package:flutter/material.dart';

import '../preferences/preferences.dart';
import '../utils/nav_drawer_empresa.dart';

class PortalEmpresa extends StatelessWidget {
  const PortalEmpresa();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( Preferences.nombreEmpresa ),
        centerTitle: true
      ),
      drawer: NavDrawerEmpresa(),
      body: Container(),
    );
  }
}