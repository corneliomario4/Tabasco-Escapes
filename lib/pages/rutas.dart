import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabasco_escapes/pages/rutas_grid.dart';
import 'package:tabasco_escapes/utils/bottom_bar.dart';

import '../utils/nav_drawer.dart';

class Rutas extends StatefulWidget {
  const Rutas({Key? key}) : super(key: key);

  @override
  State<Rutas> createState() => _RutasState();
}

class _RutasState extends State<Rutas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rutas del estado de Tabasco"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "¡Bienvenidos a Tabasco, el estado donde la aventura, la cultura, la naturaleza y la gastronomía se unen para ofrecer una experiencia única!",
                  style: GoogleFonts.lato(fontSize: 15),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: RutasGrid()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(current_index: 2),
      drawer: const NavDrawer(),
    );
  }
}
