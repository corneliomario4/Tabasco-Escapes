import 'package:image_picker/image_picker.dart';

Future<List<XFile>?> selectImages() async {
  final ImagePicker _picker = ImagePicker();

  //final XFile? image = await _picker.pickImage(source: source);

  final List<XFile>? image = await _picker.pickMultipleMedia();

  image!.forEach((element) { 
    print(element.path);
  });

  return image;
}

Future<XFile?> selectImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();

  final XFile? image = await _picker.pickImage(source: source);

  
  return image;
}