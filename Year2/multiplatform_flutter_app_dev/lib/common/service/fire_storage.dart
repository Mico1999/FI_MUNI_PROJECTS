import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FireStorage {
  final _storage = FirebaseStorage.instance.ref();

  void uploadImage(String name) async {
    final referenceImageToUpload = _storage.child(name);

    try {
      final data = await rootBundle.load(name);
      final bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await referenceImageToUpload.putData(bytes);
    } catch (e) {
      return;
    }
  }

  void uploadImageFile(XFile file) async {
    final referenceImageToUpload = _storage.child(file.name);

    try {
      await referenceImageToUpload.putData(await file.readAsBytes());
    } catch (e) {
      print(e);
      print(file.path);
      print(file.name);
      return;
    }
  }

  Future<Uint8List> downloadImage(String name) async {
    try {
      final image = _storage.child(name);
      final data = await image.getData();
      return data!.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } catch (e) {
      return Future.error(e);
    }
  }
}
