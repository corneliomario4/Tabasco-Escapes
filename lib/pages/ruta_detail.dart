import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabasco_escapes/models/municipios.dart';
import 'package:tabasco_escapes/pages/municipio_detail.dart';
import 'package:tabasco_escapes/utils/nav_drawer.dart';
import 'package:tabasco_escapes/utils/tabla_actividades.dart';

import '../models/ruta.dart';

class RutaDetal extends StatefulWidget { 
  final Ruta ruta;

  const RutaDetal({Key? key, required this.ruta}) : super(key: key);

  @override
  State<RutaDetal> createState() => _RutaDetalState();
}

class _RutaDetalState extends State<RutaDetal> {
  late List<Municipio> municipios = [];
  late Ruta route;
  bool mostrarDatos = false;

  @override
  void initState() {
    route = widget.ruta;
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ruta de ${widget.ruta.nombre}",
          style: GoogleFonts.lato(color: Colors.white, fontSize: 18),
        ),
      ),
      drawer: const NavDrawer(),
      body: mostrarDatos
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      child: CarouselSlider(
                          items: widget.ruta.header.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Image(
                                  image: NetworkImage(i),
                                  fit: BoxFit.cover,
                                );
                              },
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 400,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                            scrollDirection: Axis.horizontal,
                          )),
                    ),
                    const SizedBox(height: 10),
                    Container(
                        margin: const EdgeInsets.all(20),
                        child: Row(children: stars(widget.ruta))),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        widget.ruta.descripcion,
                        style: GoogleFonts.lato(fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Municipios que pertenecen a esta ruta",
                              style: GoogleFonts.lato(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            iconBar(),
                          ],
                        )),
                        TablaActividades(
                          ruta: widget.ruta.id, 
                        )
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  List<Widget> stars(Ruta ruta) {
    List<Widget> star = [];

    star.add(Container(
      margin: const EdgeInsets.only(right: 10),
      child: Text(
        ruta.nombre,
        style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ));

    if (ruta.rate > 0) {
      for (int i = 1; i <= 5; i++) {
        late Widget estrella;
        if (i <= ruta.rate.toInt()) {
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

  Widget iconBar() {
    List<Widget> mpos = [];
    municipios.isNotEmpty
        // ignore: avoid_function_literals_in_foreach_calls
        ? municipios.forEach((element) {
            Widget item = GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MunicipioDetail(
                      municipio: element,
                    ),
                  ),
                );
              },
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                width: 130,
                height: 130,
                child: Card(
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 60,
                            child: Image(
                              image: NetworkImage(element.logotipo),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(element.nombre),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            );

            mpos.add(item);
          })
        : null;
    Widget rowBar = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: mpos,
      ),
    );

    return rowBar;
  }

  void loadData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("Municipios")
        .where("Ruta", isEqualTo: "Rutas/${route.id}")
        .get()
        .then((event) {
      for (var municipio in event.docs) {
        Map<String, dynamic> mpo = municipio.data();
        municipios.add(Municipio.fromMap(mpo, municipio.id));
      }
    });

    setState(() {
      mostrarDatos = true;
    });
  }
}
