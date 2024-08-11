import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tabasco_escapes/pages/ruta_detail.dart';

import '../models/ruta.dart';

// ignore: must_be_immutable
class RutasGrid extends StatefulWidget {
  RutasGrid({Key? key}) : super(key: key);

  ScrollController controller = ScrollController();
  @override
  State<RutasGrid> createState() => _RutasGridState();
}

class _RutasGridState extends State<RutasGrid> {
  List<Ruta> rutas = [];
  double scrolLActual = 0;

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return rutas.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MasonryGridView.count(
              controller: widget.controller,
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: rutas.length,
              itemBuilder: (context, index) {
                return _Tile(
                  index: index,
                  route: rutas[index],
                );
              },
            ),
          );
  }

  void loadData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("Rutas")
        .orderBy("Nombre", descending: true)
        .get()
        .then((event) {
      for (var municipio in event.docs) {
        Map<String, dynamic> mpo = municipio.data();
        rutas.add(Ruta(
            header: mpo["header"],
            id: municipio.id,
            descripcion: mpo["Descripcion"],
            logotipo: mpo["Logotipo"],
            nombre: mpo["Nombre"],
            rate: double.parse(mpo["Rate"].toString())));
      }
    });

    setState(() {});
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.index, required this.route});
  final int index;
  final Ruta route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RutaDetal(
              ruta: route,
            ),
          ),
        );
      },
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          margin: const EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 60,
                  child: Image(
                    image: NetworkImage(route.logotipo),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(route.nombre),
                      Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: stars(route),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  List<Widget> stars(Ruta path) {
    List<Widget> star = [];

    if (path.rate > 0) {
      for (int i = 1; i <= 5; i++) {
        late Widget estrella;
        if (i <= path.rate.toInt()) {
          estrella = const Icon(
            Icons.star,
            color: Colors.amber,
          );
        } else {
          estrella = const Icon(
            Icons.star_border,
            color: Colors.grey,
          );
        }
        star.add(estrella);
      }
    } else {
      for (int i = 1; i <= 5; i++) {
        Widget estrella = const Icon(
          Icons.star_border,
          color: Colors.grey,
        );
        star.add(estrella);
      }
    }
    return star;
  }
}
