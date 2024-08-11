import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FloatingButton {
  final Function onPressed;
  final IconData icon;

  FloatingButton({required this.onPressed, required this.icon});
}

class FloatingMenu extends StatelessWidget {
  final bool mostrar;

  final Color backgroundColor;
  final Color activeColor; // black
  final Color inactiveColor;

  final List<FloatingButton> items;

  const FloatingMenu(
      {Key? key,
      this.mostrar = true,
      this.backgroundColor = Colors.white,
      this.activeColor = Colors.black,
      this.inactiveColor = Colors.blueGrey,
      required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _MenuModel(),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: (mostrar) ? 1 : 0,
        child: Builder(
          builder: (BuildContext context) {
            Provider.of<_MenuModel>(context).backgroundColor = backgroundColor;
            Provider.of<_MenuModel>(context).activeColor = activeColor;
            Provider.of<_MenuModel>(context).inactiveColor = inactiveColor;

            return _FloatingMenuBackground(
              child: _MenuItems(items),
            );
          },
        ),
      ),
    );
  }
}

class _FloatingMenuBackground extends StatelessWidget {
  final Widget child;

  const _FloatingMenuBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Provider.of<_MenuModel>(context).backgroundColor;

    return Container(
      child: child,
      width: 250,
      height: 60,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.blueGrey,
              blurRadius: 10,
            )
          ]),
    );
  }
}

class _MenuItems extends StatelessWidget {
  final List<FloatingButton> menuItems;

  const _MenuItems(this.menuItems);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
            menuItems.length, (i) => _FloatingMenuButton(i, menuItems[i])));
  }
}

class _FloatingMenuButton extends StatelessWidget {
  final int index;
  final FloatingButton item;

  const _FloatingMenuButton(this.index, this.item);

  @override
  Widget build(BuildContext context) {
    final itemSeleccionado = Provider.of<_MenuModel>(context).itemSeleccionado;

    final menuModel = Provider.of<_MenuModel>(context);

    return GestureDetector(
      onTap: () {
        Provider.of<_MenuModel>(context, listen: false).itemSeleccionado =
            index;
        item.onPressed();
      },
      behavior: HitTestBehavior.translucent,
      child: Icon(
        item.icon,
        size: (itemSeleccionado == index) ? 30 : 25,
        color: (itemSeleccionado == index)
            ? menuModel.activeColor
            : menuModel.inactiveColor,
      ),
    );
  }
}

class _MenuModel with ChangeNotifier {
  int _itemSeleccionado = 0;

  Color backgroundColor = Colors.white;
  Color activeColor = Colors.black;
  Color inactiveColor = Colors.blueGrey;

  int get itemSeleccionado => _itemSeleccionado;

  set itemSeleccionado(int index) {
    _itemSeleccionado = index;
    notifyListeners();
  }
}
