import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabasco_escapes/models/municipios.dart';
import 'package:tabasco_escapes/pages/mapasPage.dart';
import 'package:tabasco_escapes/pages/ruta_detail.dart';
import 'package:tabasco_escapes/utils/nav_drawer.dart';
import 'package:tabasco_escapes/utils/tabla_actividades.dart';
import 'package:weather/weather.dart';

import '../models/ruta.dart';

class MunicipioDetail extends StatefulWidget {
  final Municipio municipio;

  const MunicipioDetail({Key? key, required this.municipio}) : super(key: key);

  @override
  State<MunicipioDetail> createState() => _MunicipioDetailState();
}

class _MunicipioDetailState extends State<MunicipioDetail> {
  late Map<String, dynamic> finalData;
  late Ruta route;
  bool mostrarDatos = false;
  double temperature = 0;
  String weatherDescription = "Soleado";
  String icontext = "";

  @override
  void initState() {
    loadData(widget.municipio.ruta);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.municipio.nombre,
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
                          items: widget.municipio.headerImages.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Image(
                                  image: NetworkImage(i.toString()),
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
                        child: Row(children: stars(widget.municipio))),
                    iconBar(widget.municipio),
                    
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        widget.municipio.descripcion,
                        style: GoogleFonts.lato(fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    TablaActividades(
                      municipio: widget.municipio.idMunicipio ,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: MapScreen(
                        lat: widget.municipio.lat,
                        long: widget.municipio.long,
                      ),
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

  List<Widget> stars(Municipio municipio) {
    List<Widget> star = [];

    star.add(Container(
      margin: const EdgeInsets.only(right: 10),
      child: Text(
        municipio.nombre,
        style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ));

    if (municipio.rate > 0) {
      for (int i = 1; i <= 5; i++) {
        late Widget estrella;
        if (i <= municipio.rate.toInt()) {
          estrella = GestureDetector(
            onTap: () {
              votar(i, municipio.idMunicipio, municipio.rate);
            },
            child: const Icon(
              Icons.star,
              color: Colors.amber,
            ),
          );
        } else {
          estrella = GestureDetector(
            onTap: () {
              votar(i, municipio.idMunicipio, municipio.rate);
            },
            child: const Icon(
              Icons.star_border,
              color: Colors.grey,
            ),
          );
        }
        star.add(estrella);
      }
    } else {
      for (int i = 1; i <= 5; i++) {
        Widget estrella = GestureDetector(
          onTap: () {
            votar(i, municipio.idMunicipio, municipio.rate);
            print(municipio.nombre);
          },
          child: const Icon(
            Icons.star_border,
            color: Colors.grey,
          ),
        );
        star.add(estrella);
      }
    }
    return star;
  }

  Widget iconBar(Municipio municipio) {
    Widget rowBar = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          itemRowBar(municipio),
          weatherItem(
              weatherDescription,
              temperature > 29 ? Icons.sunny : Icons.cloud,
              temperature > 29 ? Colors.amber : Colors.blueGrey)
        ],
      ),
    );

    return rowBar;
  }

  Widget itemRowBar(Municipio municipio) {
    Widget item = Container(
      margin: const EdgeInsets.only(top: 10, left: 20),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RutaDetal(ruta: route),
                  ),
                );
              },
              child: SizedBox(
                width: 40,
                child: Image(image: NetworkImage(route.logotipo)),
              )),
          const SizedBox(
            width: 5,
          ),
          Text(
            route.nombre,
            style: GoogleFonts.lato(fontSize: 14),
          )
        ],
      ),
    );

    return item;
  }

  Widget weatherItem(String text, IconData icon, Color color) {
    Widget item = Container(
      margin: const EdgeInsets.only(top: 10, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Image(
                image: NetworkImage(
                    "http://openweathermap.org/img/w/$icontext.png",
                    scale: 1)),
          ),
          SizedBox(
            width: 150,
            child: ListTile(
              title: Text(
                "${temperature.toInt()} °C",
                style:
                    GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(weatherDescription),
            ),
          )
        ],
      ),
    );

    return item;
  }

  void loadData(String coleccion) async {
    List<String> path = coleccion.split("/");
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference colRef = db.collection(path[0].trim());
    DocumentReference docRef = colRef.doc(path[1].trim());
    DocumentSnapshot doc = await docRef.get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    finalData = data;
    List header = data["header"];

    await getWeather(lat: widget.municipio.lat, long: widget.municipio.long);

    setState(() {
      route = Ruta(
          id: doc.id,
          descripcion: data["Descripcion"],
          logotipo: data["Logotipo"],
          nombre: data["Nombre"],
          header: header,
          rate: double.parse(data["Rate"].toString()));
    });
    mostrarDatos = true;
  }

  void votar(int i, String id, double rate) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    double rateActual = (rate + i) / 2;
    final washingtonRef = db.collection("Municipios").doc(id);
    await washingtonRef.update({"Rate": rateActual}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Has otorgado un $i de puntuación a este municipio")));
      setState(() {});
    },
        onError: (e) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Tu voto no se ha registrado correctamente; Error: ${e.toString()}"))));
  }

  getWeather({required double lat, required double long}) async {
    WeatherFactory wf = WeatherFactory("3d2b21d5dc5f920d0949698a8fa4f764",
        language: Language.SPANISH);
    Weather w = await wf.currentWeatherByLocation(lat, long);
    weatherDescription = "${w.weatherDescription}";
    temperature = w.temperature?.celsius as double;
    icontext = w.weatherIcon.toString();
  }
}
