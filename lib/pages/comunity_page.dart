import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:tabasco_escapes/services/upload_to_storage.dart';
import 'package:tabasco_escapes/utils/bottom_bar.dart';
import 'package:tabasco_escapes/utils/nav_drawer.dart';

import '../services/select_image.dart';

class ComunityPage extends StatefulWidget {
  ComunityPage({Key? key}) : super(key: key);

  @override
  State<ComunityPage> createState() => _ComunityPageState();
}

class _ComunityPageState extends State<ComunityPage> {
  late File image_to_upload;
  late String url = "";
  TextEditingController texto_publicacion = TextEditingController();
  List<Map<String, dynamic>> publicaciones = [];

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comunidad"),
        centerTitle: true,
      ),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "profile");
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 5),
                        width: 50,
                        child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              FirebaseAuth.instance.currentUser?.photoURL !=
                                      null
                                  ? FirebaseAuth.instance.currentUser!.photoURL
                                      as String
                                  : "https://firebasestorage.googleapis.com/v0/b/tabasco-escapes.appspot.com/o/assets%2FuserIcon.png?alt=media&token=aceabc59-71d8-45e2-be4e-376a4f5f4c7c",
                            )),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: TextFormField(
                        initialValue: "",
                        onChanged: (value) {
                          texto_publicacion.text = value;
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: "¿Que estás pensando?",
                            fillColor: Colors.white),
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: cargarImagen,
                            icon: Icon(Icons.image_search,
                                size: 30, color: Colors.green)),
                        IconButton(
                          icon: Icon(Icons.send, size: 30, color: Colors.blue),
                          onPressed: send,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.6,
                child: publicaciones.length > 0
                    ? ListView.builder(
                        itemCount: publicaciones.length,
                        itemBuilder: (context, index) {
                          url = publicaciones[index]["imagen"];

                          var fecha = publicaciones[index]['fecha'].toDate();
                          String usario = publicaciones[index]["usuario"];
                          String fecha_string =
                              fecha.toString().split(".").first;
                          String id_publicacion = "${usario}-${fecha_string}";
                          DateTime fecha2 = DateTime.parse(fecha.toString());
                          List likes = publicaciones[index]["likes"];
                          print("no. de likes: ${likes.length}");

                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: Card(
                              elevation: 10,
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(url),
                                      )),
                                  Container(
                                      height: 80,
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                  publicaciones[index][
                                                                  "descripcion"]
                                                              .toString()
                                                              .length >
                                                          30
                                                      ? publicaciones[index]
                                                              ["descripcion"]
                                                          .toString()
                                                          .substring(0, 29)
                                                      : publicaciones[index]
                                                              ["descripcion"]
                                                          .toString(),
                                                  style: GoogleFonts.lato(
                                                      fontSize: 16)),
                                              Text(
                                                  "${fecha2.day}/${fecha2.month}/${fecha2.year}",
                                                  style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16))
                                            ],
                                          ),
                                          SizedBox(
                                            width: publicaciones[index]
                                                            ["descripcion"]
                                                        .toString()
                                                        .length >=
                                                    20
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: likes
                                                          .contains(FirebaseAuth.instance.currentUser!.uid)
                                                      ? () {
                                                          likes.remove(FirebaseAuth.instance.currentUser!.uid);
                                                          unLikear(id_publicacion,likes);
                                                        }
                                                      : () {
                                                          likes.add(FirebaseAuth.instance.currentUser!.uid);
                                                          likear(id_publicacion,
                                                              usario, likes);
                                                        },
                                                  icon: Icon(
                                                      likes.contains(FirebaseAuth.instance.currentUser!.uid)
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color:
                                                          likes.contains(FirebaseAuth.instance.currentUser!.uid)
                                                              ? Colors.red
                                                              : Colors.grey)),
                                              Text(likes.length.toString())
                                            ],
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          );
                        })
                    : Center(child: CircularProgressIndicator()),
              )
            ],
          )),
      drawer: NavDrawer(),
      bottomNavigationBar: BottomBar(current_index: 2),
    );
  }

  cargarImagen() async {
    final image = await selectImage(ImageSource.gallery);
    if (image != null) {
      image_to_upload = File(image.path);
      final ProgressDialog pr = ProgressDialog(context,
          isDismissible: false, type: ProgressDialogType.download);
      pr.style(message: "Cargando imagen...", elevation: 15);

      pr.show();

      url = await upload(
              image_to_upload, FirebaseAuth.instance.currentUser?.uid as String)
          .whenComplete(() {
        pr.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Imagen cargada correctamente"),
        ));
      });
      print(url);
    }
  }

  send() async {
    late Map<String, dynamic> post;
    final now = DateTime.now();

    if (texto_publicacion.text != "" && url != "") {
      post = {
        "usuario": FirebaseAuth.instance.currentUser!.uid,
        "descripcion": texto_publicacion.text,
        "imagen": url,
        "fecha": now,
        "likes": []
      };
    }
    if (url != "" && texto_publicacion.text == "") {
      post = {
        "usuario": FirebaseAuth.instance.currentUser?.uid,
        "imagen": url,
        "descripcion": "",
        "fecha": now,
        "likes": []
      };
    }
    final ProgressDialog pr = ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.download);
    pr.style(message: "Cargando pulicación...", elevation: 15);

    pr.show();
    FirebaseFirestore db = FirebaseFirestore.instance;
    print(post);
    await db
        .collection("Publicaciones")
        .doc(
            "${FirebaseAuth.instance.currentUser!.uid}-${now.toString().split(".").first}")
        .set(post)
        .whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Publicación subida correctamente")));

      setState(() {
        pr.hide();
        texto_publicacion.text = "";
        url="";
        getPosts();
      });
    });
  }

  getPosts() async {
    publicaciones = [];
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("Publicaciones").orderBy("fecha", descending: true).get().then((value) {
      for (var post in value.docs) {
        Map<String, dynamic> publi = post.data();
        publicaciones.add(publi);
      }
    });

    setState(() {});
  }

  likear(String id_post, String usuario, List likes) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final postsRef = db.collection("Publicaciones").doc(id_post);
    await postsRef.update({"likes": likes}).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Has dado like a esta pulicación")));
      setState(() {
        getPosts();
      });
    });
  }

  unLikear(String id_post,List likes) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final postsRef = db.collection("Publicaciones").doc(id_post);
    await postsRef.update({"likes": likes}).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ya no te gusta esta publicación")));
      setState(() {
        getPosts();
      });
    });
  }
}
