import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tabasco_escapes/models/municipios.dart';
import 'package:tabasco_escapes/pages/municipio_detail.dart';

// ignore: must_be_immutable
class MunicipiosGrid extends StatefulWidget {
  MunicipiosGrid({Key? key}) : super(key: key);

  @override
  State<MunicipiosGrid> createState() => _MunicipiosGridState();
}

class _MunicipiosGridState extends State<MunicipiosGrid> {
  List<Municipio> municipios = [];
  double scrolLActual = 0;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return municipios.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: municipios.length,
              itemBuilder: (context, index) {
                return _Tile(
                  index: index,
                  muncipio: municipios[index],
                );
              },
            ),
          );
  }

  void loadData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("Municipios")
        .orderBy("Nombre", descending: false)
        .get()
        .then((event) {
      for (var municipio in event.docs) {
        Map<String, dynamic> mpo = municipio.data();
        municipios.add(Municipio.fromMap(mpo, municipio.id));
      }
    });

    setState(() {});
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.index, required this.muncipio});
  final int index;
  final Municipio muncipio;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MunicipioDetail(
              municipio: muncipio,
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
                    image: NetworkImage(muncipio.logotipo),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(muncipio.nombre),
                      Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: stars(muncipio),
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

  List<Widget> stars(Municipio municipio) {
    List<Widget> star = [];

    if (municipio.rate > 0) {
      for (int i = 1; i <= 5; i++) {
        late Widget estrella;
        if (i <= municipio.rate.toInt()) {
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
