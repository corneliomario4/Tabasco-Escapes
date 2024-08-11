import 'package:flutter/material.dart';
import 'package:tabasco_escapes/utils/headers.dart';

import '../preferences/preferences.dart';

class NavDrawerEmpresa extends StatelessWidget {
  const NavDrawerEmpresa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(children: [
      Stack(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              child: const HeaderWaveGradient()),
          Positioned(
              top: 80,
              right: 50,
              child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(Preferences.logotipo))),
          Positioned(
              top: 40,
              left: 20,
              child: Text(
                Preferences.nombreEmpresa,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ))
        ],
      ),
      menuItem(
          context: context, titulo: "Inicio", icono: Icons.home, ruta: "home"),
      menuItem(context: context, titulo: "Perfil empresarial", icono: Icons.store , ruta: "dashboard"),
      menuItem(context: context, titulo: "Mis anuncios", icono: Icons.ads_click , ruta: "anuncios"),
      menuItem(context: context, titulo: "Mis productos", icono: Icons.shop , ruta: "dashboard")
    ]);
  }

  Padding menuItem(
      {required BuildContext context,
      required String titulo,
      required IconData icono,
      required String ruta}) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ListTile(
        title: Text(titulo),
        leading: Icon(icono),
        onTap: () {
          Navigator.pushNamed(context, ruta);
        },
      ),
    );
  }
}
