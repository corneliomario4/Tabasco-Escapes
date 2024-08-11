import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TablaActividades extends StatefulWidget {
  late String ruta;
  late String municipio;

  TablaActividades(
      {Key? key,
      this.ruta = "",
      this.municipio = ""})
      : super(key: key);

  @override
  State<TablaActividades> createState() => _TablaActividadesState();
}

class _TablaActividadesState extends State<TablaActividades> {

  late List<Map<String, dynamic>> actividades = [];

  @override
  void initState() {
    getActividades();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(150),
          1: FixedColumnWidth(150)
        },
        border: TableBorder.symmetric(
        inside: BorderSide(width: 2, color: Colors.grey),
        outside: BorderSide(width: 2, color: Colors.grey), 
      ),
        children: getRows()
      ),
    );
  }

  List<TableRow> getRows(){
    List<TableRow> rows = [];
    rows.add(TableRow(

      decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Nombre", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ),
              
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCell(
                child: Text("Descripcion", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),
            )
          ]
        )
      );
    for (var i = 0; i < actividades.length; i++) {
      rows.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCell(
                child: Text(actividades[i]["Nombre"], textAlign: TextAlign.justify,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCell(
                child: Text(actividades[i]["Descripcion"], textAlign: TextAlign.justify,),
              ),
            )
          ]
        )
      );
    }

    return rows;
  }

  void getActividades() async {

    String order = "Ruta";

    if(widget.municipio != "" && widget.ruta!=""){
      order = "Ruta";
    }
    else if(widget.municipio!="" && widget.ruta ==""){
      order = "Municipio";
    }
    else if(widget.municipio=="" && widget.ruta !=""){
      order = "Ruta";
    }


   actividades.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("Actividades").where(order, isEqualTo: order=="Ruta" ? widget.ruta : widget.municipio).get().then((value) {
      print(value.docs);
      for (var actividad in value.docs) {
        Map<String, dynamic> publi = actividad.data();
        print(publi);
        actividades.add(publi);
      }

      setState(() {
        print(actividades);
      });
    });
  }
}
