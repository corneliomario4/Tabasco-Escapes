class Actividades {
  late String nombre;
  late String descripcion;
  late String ruta;
  late String municipio;
  late String id;


  Actividades({required this.id, required this.nombre, required this.descripcion, required this.ruta, required this.municipio});

  @override
  String toString() {
    return "${this.nombre}";
  }
}

