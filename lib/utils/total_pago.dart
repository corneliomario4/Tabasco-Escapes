import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../preferences/preferences.dart';

// ignore: must_be_immutable
class TotalPagoWidget extends StatelessWidget {

  late String nombre;
  late String rfc;
  late String selectedMunicipio;

  TotalPagoWidget({required this.nombre, required this.rfc, required this.selectedMunicipio});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
        width: width,
        height: 110,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 158, 30, 68),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total a pagar:",
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    "200.00 MXN",
                    style: GoogleFonts.lato(fontSize: 22, color: Colors.white),
                  )
                ]),
            _BtnPay(nombre: this.nombre, rfc: this.rfc, selectedMunicipio: this.selectedMunicipio)
          ],
        ));
  }
}

// ignore: must_be_immutable
class _BtnPay extends StatefulWidget {

  late String nombre;
  late String rfc;
  late String selectedMunicipio;

  _BtnPay({required this.nombre, required this.rfc, required this.selectedMunicipio});

  @override
  State<_BtnPay> createState() => _BtnPayState();
}

class _BtnPayState extends State<_BtnPay> {
  @override
  Widget build(BuildContext context) {
    // ignore: dead_code
    return true ? buildTarjetaPay(context) : buildAppleAndGooglePay(context);
  }

  Widget buildTarjetaPay(BuildContext context) {
    return MaterialButton(
      onPressed: () async  {
        try{
          final response = await http.post(Uri.parse("https://stripepaymentintentrequest-kbgvj37upq-uc.a.run.app"), body: {
            'email': FirebaseAuth.instance.currentUser?.email.toString(),
            'amount': '20'
          });

          final decodedData = json.decode(response.body);

          await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: decodedData['paymentIntent'],
            merchantDisplayName: "Upgrade to Plus",
            customerId: decodedData['customer'],
            customerEphemeralKeySecret: decodedData['ephemeralKey'],
            
          ));

          await Stripe.instance.presentPaymentSheet();
          

          //pagoexitoso

          FirebaseFirestore db = FirebaseFirestore.instance;

            DateTime now = DateTime.now();
            String formattedDate = DateFormat('yyyy-MM-dd').format(now);
            db.collection("Empresas").doc("${FirebaseAuth.instance.currentUser!.uid}").set({
              "Nombre" : this.widget.nombre,
              "rfc": this.widget.rfc,
              "municipio": this.widget.selectedMunicipio,
              "last_payment": formattedDate
            }).whenComplete((){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Cuenta actualizada satisfactoriamente")));

              setState(() {
                Preferences.isUpgraded = true;
                Navigator.popAndPushNamed(context, "home");
              });
            });
          
          
          

        } catch(e){
          if(  e is StripeException ){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Un error ha ocurrido: ${ e.error.localizedMessage }")));
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Un error ha ocurrido: ${ e }")));
          }
        }
      },
      minWidth: 150,
      height: 45,
      shape: StadiumBorder(),
      elevation: 10,
      color: Colors.white,
      child: Row(children: [
        Icon(FontAwesomeIcons.solidCreditCard, color: Colors.black, size: 30),
        Text("  Pagar", style: GoogleFonts.montserrat(fontSize: 15))
      ]),
    );
  }

  Widget buildAppleAndGooglePay(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      minWidth: 150,
      height: 45,
      shape: StadiumBorder(),
      elevation: 10,
      color: Colors.white,
      child: Row(children: [
        Platform.isAndroid
            ? Icon(FontAwesomeIcons.google)
            : Icon(FontAwesomeIcons.apple, color: Colors.black, size: 30),
        Text("  Pagar", style: GoogleFonts.montserrat(fontSize: 15))
      ]),
    );
  }
}
