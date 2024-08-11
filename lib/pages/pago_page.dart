import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/municipios.dart';
import '../utils/total_pago.dart';

class PagoPage extends StatefulWidget {

  @override
  State<PagoPage> createState() => _PagoPageState();
}

class _PagoPageState extends State<PagoPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController razonSocialController = TextEditingController();
  TextEditingController rfcController = TextEditingController();
  late String selectedMunicipio="16MnH5eCUMSKteFore8c";
  List<Municipio> municipios = [];

  @override
  void initState(){
    loadData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagar Suscripcion"),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: (){})
        ],
      ),
      body: Stack(
        children: [
          Container(
          margin: EdgeInsets.all(20),
          child: form()
        ),
        Positioned(
          bottom: 0,
          child: TotalPagoWidget(nombre: razonSocialController.text, rfc:rfcController.text, selectedMunicipio: selectedMunicipio)),]
      ),
    );
  }


  Widget form(){
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: razonSocialController,
              decoration: InputDecoration(
                labelText: 'Razón Social',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: rfcController,
              decoration: InputDecoration(
                labelText: 'RFC',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedMunicipio,
              onChanged: (value) {
                setState(() {
                  selectedMunicipio = value!;
                  print(selectedMunicipio);
                });
              },
              items: !municipios.isEmpty?  municipios.map((municipio) {
                return DropdownMenuItem<String>(
                  value: municipio.idMunicipio,
                  child: Text(municipio.nombre),
                );
              }).toList() : [
                DropdownMenuItem<String>(
                  value: "16MnH5eCUMSKteFore8c",
                  child: Text("Tenosique"),
                ),
              ],
              decoration: InputDecoration(
                labelText: 'Municipio',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Realizar acción con los datos del formulario
                  String razonSocial = razonSocialController.text;
                  String rfc = rfcController.text;
                  print('Razón Social: $razonSocial');
                  print('RFC: $rfc');
                }
              },
              child: Text('Enviar'),
            ),
          ],
        ),);
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