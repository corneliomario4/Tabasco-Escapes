import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
late Reference ref;

Future<String> upload(File image, String uid) async {
  final String imageName = image.path.split("/").last;
  try {
    ref = _storage.ref().child("publicaciones").child(uid).child(imageName);
  } on Exception catch (e) {
    print(e.toString());
  }

  final storageSnapshot = await ref.putFile(image);
  String url = await storageSnapshot.ref.getDownloadURL();

  return url;
}

Future<List<String>> uploadMultipleFiles(List<XFile> files, String uid) async {
  List<String> urls = [];
  String url="";
  
  for(int i = 0; i<files.length; i++){
    final File imageFile = File(files[i].path);
    final String imageName = imageFile.path.split("/").last;
    try {
      ref = _storage.ref().child("anuncios").child(uid).child(imageName);
    } on Exception catch (e) {
      print(e.toString());
    }

    final storageSnapshot = await ref.putFile(imageFile);
    url = await storageSnapshot.ref.getDownloadURL();
    urls.add(url);
  }
  print(urls);
  return urls;
}
