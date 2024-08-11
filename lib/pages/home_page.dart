import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabasco_escapes/utils/nav_drawer.dart';

import '../utils/bottom_bar.dart';
import 'municipios_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scroll = ScrollController();
  double scrolLActual = 0;

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                "assets/img/icono.png",
                width: 50,
              ),
              Text("PlayTab",
                  style: GoogleFonts.lato(color: Colors.white, fontSize: 18)),
            ],
          ),
          elevation: 6,
          backgroundColor: const Color.fromARGB(255, 158, 30, 68),
          centerTitle: true,
          leading: Row(
            children: [
              Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    // ignore: prefer_const_constructors
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ));
              }),
            ],
          )),
      body: MunicipiosGrid(),
      bottomNavigationBar: BottomBar(
        current_index: 0,
      ),
      drawer: const NavDrawer(),
    );
  }
}

class MenuModel with ChangeNotifier {
  bool _mostrar = true;

  bool get mostrar => _mostrar;

  set mostrar(bool valor) {
    _mostrar = valor;
    notifyListeners();
  }
}
