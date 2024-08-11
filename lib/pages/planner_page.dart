import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabasco_escapes/utils/bottom_bar.dart';

import '../models/actividades.dart';
import '../utils/nav_drawer.dart';


class PlannerPage extends StatefulWidget {
  const PlannerPage();

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {

  late DateTime checkIn = DateTime(DateTime.now().year);
  late DateTime checkOut = DateTime(DateTime.now().year);
  List<String> ruta=[];
  late String origen;
  late String metodoTransporte;
  TextEditingController checkInController = TextEditingController();
  TextEditingController checkOutController = TextEditingController();
  TextEditingController origenController = TextEditingController();
  List<Map<String, dynamic>> rutas = [];

  @override
  void initState() {
    loadRoutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planea tu viaje"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width /3,
                      child: TextFormField(
                        decoration: InputDecoration(hintText: 'Check In'),
                        controller: checkInController,
                        maxLength: 15,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context, 
                            locale: Locale("es", "MX"),
                            initialDate: DateTime.now(), 
                            firstDate: DateTime(DateTime.now().year), 
                            lastDate: DateTime(DateTime.now().year + 2)
                          );
                    
                          if(picked != null) setState((){
                            checkIn = picked;
                            checkInController.text = "${picked.day} - ${picked.month} - ${picked.year}";
                          });
                    
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width /3,
                      child: TextFormField(
                        decoration: InputDecoration(hintText: 'Check Out'),
                        controller: checkOutController,
                        maxLength: 15,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context, 
                            locale: Locale("es", "MX"),
                            initialDate: DateTime.now(), 
                            firstDate: DateTime(DateTime.now().year), 
                            lastDate: DateTime(DateTime.now().year + 2)
                          );
                    
                          if(picked != null) setState((){
                            checkOut = picked;
                            checkOutController.text = "${picked.day} - ${picked.month} - ${picked.year}";
                          });
                    
                        },
                      ),
                    ),
                  ]
                )
              ),

              Text(
                "¿Que rutas te gustaría conocer?",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontStyle: FontStyle.italic
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical:10),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: getRoutes()
                  ),
                )

              ),

               Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical:10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width-40,
                      child: TextFormField(
                        decoration: InputDecoration(hintText: 'Estado o País de Origen'),
                        controller: origenController,
                        
                      )
                    )
                  ],
                ),
              ),

              Center(
                child: GestureDetector(
                  onTap: (){
                    planearViaje();
                  },
                  child: Card(
                    elevation: 10,
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center ,
                        children: [
                          Icon(
                            Icons.calendar_month, color: Colors.blue, size: 40,
                          ),
                          Text("Planear", style: GoogleFonts.lato(fontSize: 18, fontStyle: FontStyle.italic))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]
          )
        ),
      ),
      drawer: NavDrawer(),
      bottomNavigationBar: BottomBar(current_index: 2),
    );
  }


  List<Widget> getRoutes(){
    List<Widget> rutasWidget = [];
    if(rutas.isEmpty){
      rutasWidget.add(Center(child: CircularProgressIndicator()));
    }
    else{

      for (var i = 0; i < rutas.length; i++) {
        rutasWidget.add(
          Container(
            width: 180,
            height: 50,
            child: ListTile(
              title: Text(rutas[i]["nombre"]),
              leading: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: rutas[i]["checked"],
              onChanged: (bool? value){
                if(rutas[i]["checked"]==false){
                  rutas[i]["checked"] = true;
                  ruta.add(rutas[i]["id"]);
                }
                else{
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
        .collection("Rutas")
        .orderBy("Nombre", descending: true)
        .get()
        .then((event) {
      for (var municipio in event.docs) {
        Map<String, dynamic> mpo = municipio.data();
        Map<String, dynamic> data = {
          "id": municipio.id,
          "nombre": mpo["Nombre"],
          "logo": mpo["Logotipo"],
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

  planearViaje() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Actividades> actividades = [];

    for (var i = 0; i < ruta.length; i++) {
      await db
      .collection("Actividades")
      .where("Ruta", isEqualTo: ruta[i])
      .get()
      .then((event) {
        for (var actividad in event.docs) {
          Map<String, dynamic> act = actividad.data();
          actividades.add(
            Actividades(
              id: actividad.id,
              nombre: actividad["Nombre"],
              descripcion: actividad["Descripcion"],
              ruta: actividad["Ruta"],
              municipio: actividad["Municipio"]
            )
          );
        }
      });
    }
    print("Check In: ${checkIn} / CheckOut: ${checkOut}");
    print("Origen: ${origenController.text}");
    print(checkOut.difference(checkIn).inDays.toString());
    print(actividades);
    
  }

}