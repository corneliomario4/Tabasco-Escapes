import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tabasco_escapes/preferences/preferences.dart';
import 'package:tabasco_escapes/utils/headers.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

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
                  backgroundImage: NetworkImage(FirebaseAuth
                              .instance.currentUser?.photoURL !=
                          null
                      ? FirebaseAuth.instance.currentUser!.photoURL as String
                      : "https://firebasestorage.googleapis.com/v0/b/tabasco-escapes.appspot.com/o/assets%2FuserIcon.png?alt=media&token=aceabc59-71d8-45e2-be4e-376a4f5f4c7c"))),
          Positioned(
              top: 40,
              left: 20,
              child: Text(
                FirebaseAuth.instance.currentUser?.displayName != null
                    ? FirebaseAuth.instance.currentUser?.displayName as String
                    : FirebaseAuth.instance.currentUser?.email as String,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ))
        ],
      ),
      menuItem(
          context: context, titulo: "Inicio", icono: Icons.home, ruta: "home"),
      menuItem(
          context: context, titulo: "Rutas", icono: Icons.route, ruta: "rutas"),
      menuItem(
          context: context,
          titulo: "Arma tu viaje",
          icono: Icons.airplane_ticket,
          ruta: "planner"),
      menuItem(
          context: context,
          titulo: "Comunidad",
          icono: Icons.people,
          ruta: "comunity"),
      menuItem(
          context: context,
          titulo: "Mi perfil",
          icono: Icons.person,
          ruta: "profile"),
      !Preferences.isUpgraded ? menuItem(
        context: context,
        titulo: "Actualizar a cuenta de empresa",
        icono: Icons.refresh,
        ruta: "upgrade"
      ): Container(),
      Preferences.isUpgraded ? menuItem(
        context: context,
        titulo: "Portal de empresa",
        icono: Icons.business,
        ruta: "dashboard"
      ) : Container()
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
