import 'package:flutter/material.dart';
import 'package:tabasco_escapes/utils/bottom_bar.dart';
import 'package:tabasco_escapes/utils/nav_drawer.dart';

class UpgradePage extends StatefulWidget {

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Actualizar a empresa"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: IconButton(icon: Icon(Icons.currency_exchange), onPressed: (){
              upgrade();
            })
          )
        ],
      ),
      drawer: NavDrawer(),
      bottomNavigationBar: BottomBar(current_index: 0),
      
    );
  }


  upgrade() async {
    

    Navigator.pushNamed(context, "pay");
  }
}