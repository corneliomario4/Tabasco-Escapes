class Municipio {
  late String descripcion;
  late String logotipo;
  late String nombre;
  late double rate;
  late String idMunicipio;
  late String ruta;
  late List headerImages;
  late double lat, long;

  Municipio(
      {required this.descripcion,
      required this.logotipo,
      required this.nombre,
      required this.rate,
      required this.headerImages,
      required this.ruta});

  Municipio.fromMap(Map<String, dynamic> data, String id) {
    ruta = data["Ruta"];
    rate = double.parse(data["Rate"].toString());
    nombre = data["Nombre"];
    descripcion = data["Descripcion"];
    logotipo = data["Logotipo"];
    idMunicipio = id;
    try {
      headerImages = data["header"] ??
          [
            "https://firebasestorage.googleapis.com/v0/b/tabasco-escapes.appspot.com/o/assets%2Fmunicipios%2F1.png?alt=media&token=3e2ed66a-f2e2-4295-8f01-79bff7fac46a",
            "https://firebasestorage.googleapis.com/v0/b/tabasco-escapes.appspot.com/o/assets%2Fmunicipios%2F2.png?alt=media&token=806423f7-3d1c-40c9-b85c-a5dc298e72b6",
            "https://firebasestorage.googleapis.com/v0/b/tabasco-escapes.appspot.com/o/assets%2Fmunicipios%2F3.png?alt=media&token=27f0a340-ef61-4b11-9dd9-d362c0eedec0"
          ];
    } on Exception {
      headerImages = [
        "https://firebasestorage.googleapis.com/v0/b/tabasco-escapes.appspot.com/o/assets%2Fmunicipios%2F1.png?alt=media&token=3e2ed66a-f2e2-4295-8f01-79bff7fac46a",
        "https://firebasestorage.googleapis.com/v0/b/tabasco-escapes.appspot.com/o/assets%2Fmunicipios%2F2.png?alt=media&token=806423f7-3d1c-40c9-b85c-a5dc298e72b6",
        "https://firebasestorage.googleapis.com/v0/b/tabasco-escapes.appspot.com/o/assets%2Fmunicipios%2F3.png?alt=media&token=27f0a340-ef61-4b11-9dd9-d362c0eedec0"
      ];
    }

    try {
      lat = double.parse(data["ubicacion"][0].toString());
      long = double.parse(data["ubicacion"][1].toString());
      // ignore: unused_catch_clause, empty_catches
    } on Exception catch (e) {}
  }
}
