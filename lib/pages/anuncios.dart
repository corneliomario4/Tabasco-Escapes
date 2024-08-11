import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabasco_escapes/services/select_image.dart';
import 'package:tabasco_escapes/services/upload_to_storage.dart';

import '../preferences/preferences.dart';
import '../utils/nav_drawer_empresa.dart';

class Anuncios extends StatefulWidget {
  Anuncios();

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  TextEditingController titulo = TextEditingController();
  TextEditingController fecha_inicio = TextEditingController();
  TextEditingController fecha_fin = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  List<XFile>? imagenes = [];
  List<String> urls = [];
  List<String> ruta = [];
  List<Map<String, dynamic>> rutas = [];

  @override
  void initState() {
    // TODO: implement initState
    loadRoutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis Anuncios"), centerTitle: true),
      drawer: NavDrawerEmpresa(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey, // Color del borde gris
                width: 2.0, // Ancho del borde
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  child: Column(
                children: [
                  TextFormField(
                    controller: titulo,
                    decoration: InputDecoration(hintText: "Titulo del anuncio"),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Inicio'),
                          controller: fecha_inicio,
                          maxLength: 15,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                                context: context,
                                locale: Locale("es", "MX"),
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year),
                                lastDate: DateTime(DateTime.now().year + 2));

                            if (picked != null)
                              setState(() {
                                fecha_inicio.text =
                                    "${picked.day} - ${picked.month} - ${picked.year}";
                              });
                          },
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 12),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Fin'),
                          controller: fecha_fin,
                          maxLength: 15,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                                context: context,
                                locale: Locale("es", "MX"),
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year),
                                lastDate: DateTime(DateTime.now().year + 2));

                            if (picked != null)
                              setState(() {
                                fecha_fin.text =
                                    "${picked.day} - ${picked.month} - ${picked.year}";
                              });
                          },
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: descripcion,
                    maxLength: 250,
                    decoration: InputDecoration(hintText: "Descripción"),
                  ),
                  imagenes!.isEmpty
                      ? Row(
                          children: [
                            Text("Esperando Carga de imagenes"),
                            IconButton(
                                onPressed: () async {
                                  imagenes = await selectImages();
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.upload_file,
                                  color: Colors.blue,
                                )),
                            Center(
                                child: CircularProgressIndicator(
                              color: Colors.blue,
                            ))
                          ],
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: 100,
                          child: ListView.builder(
                              itemCount: imagenes!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, position) {
                                return Card(
                                  child: Image.file(
                                      File(imagenes![position].path)),
                                );
                              }),
                        ),
                        Container(
                          child: Text("Selecciona los municipios donde deseas mostrar tu anuncio (desliza a la derecha para ver la lista completa)"),
                        ),
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: getRoutes()),
                      )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          await _displayTextInputDialog(context);
                        },
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: Colors.white, // Color del borde gris
                              width: 3.0, // Ancho del borde
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text("Subir Anuncio", style: TextStyle(color: Colors.white),),
                        ),
                      )
                    ],
                  )
                ],
              )),
            ),
          )
        ],
      )),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('¿Estas seguro?'),
            content: Text(
                "¿Las imagenes mostradas son las correctas para tu anuncio?"),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    imagenes = [];
                    urls = [];
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () async {
                  urls = await uploadMultipleFiles(
                      imagenes!, FirebaseAuth.instance.currentUser!.uid);
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  String now = DateTime.now().toString();
                  await db.collection("Anuncios").doc("A$now").set({
                    "owner": FirebaseAuth.instance.currentUser!.uid,
                    "titulo": titulo.text,
                    "descripcion": descripcion.text,
                    "fecha_inicio": fecha_inicio.text,
                    "fecha_fin": fecha_fin.text,
                    "imagenes": urls,
                    "municipios": ruta
                  }).whenComplete(() {
                    setState(() {
                      
                      titulo.text = "";
                      fecha_inicio.text = "";
                      fecha_fin.text = "";
                      descripcion.text = "";
                      imagenes = [];
                      urls = [];

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Anuncio subido correctamente")));
                      Navigator.pop(context);
                    });
                  });
                },
              ),
            ],
          );
        });
  }

  List<Widget> getRoutes() {
    List<Widget> rutasWidget = [];
    if (rutas.isEmpty) {
      rutasWidget.add(Center(child: CircularProgressIndicator()));
    } else {
      for (var i = 0; i < rutas.length; i++) {
        rutasWidget.add(Container(
          width: 200,
          height: 50,
          child: ListTile(
            title: Text(rutas[i]["nombre"]),
            leading: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: rutas[i]["checked"],
              onChanged: (bool? value) {
                if (rutas[i]["checked"] == false) {
                  rutas[i]["checked"] = true;
                  ruta.add(rutas[i]["id"]);
                } else {
                  rutas[i]["checked"] = false;
                  ruta.remove(rutas[i]["id"]);
                }
                
                setState(() {
                  
                });
              },
            ),
          ),
        ));
      }
    }
    return rutasWidget;
  }

  loadRoutes() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("Municipios")
        .orderBy("Nombre", descending: true)
        .get()
        .then((event) {
      for (var municipio in event.docs) {
        Map<String, dynamic> mpo = municipio.data();
        Map<String, dynamic> data = {
          "id": municipio.id,
          "nombre": mpo["Nombre"],
          "checked": false
        };
        rutas.add(data);
      }
    });

    setState(() {});
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Color.fromARGB(255, 158, 30, 68);
  }
}
