import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  int current_index;
  BottomBar({Key? key, required this.current_index}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List<String> pages = ['home', 'profile', 'comunity'];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 158, 30, 68),
      elevation: 10,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[400],
      currentIndex: widget.current_index,
      onTap: (value) {
        Navigator.pushNamed(context, pages[value]);
        setState(() {
          widget.current_index = value;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Inicio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts), label: 'Perfil'),
        BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'Comunidad')
      ],
    );
  }
}
