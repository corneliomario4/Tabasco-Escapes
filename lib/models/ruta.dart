

class Ruta {
  late String descripcion;
  late String logotipo;
  late String nombre;
  late double rate;
  late String id;
  late List header;

  Map<String, dynamic> finalData = {};

  Ruta(
      {required this.id,
      required this.descripcion,
      required this.logotipo,
      required this.nombre,
      required this.rate,
      required this.header});
}
