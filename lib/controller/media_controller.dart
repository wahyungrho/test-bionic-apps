import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class MediaController extends GetxController {
  XFile? pickedFile;
  final ImagePicker picker = ImagePicker();
  CollectionReference medias = FirebaseFirestore.instance.collection('medias');
  RxString statusSave = ''.obs;

  Future imageSource(String source) async {
    if (source == 'gallery') {
      pickedFile =
          await picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    } else {
      pickedFile =
          await picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    }

    return File(pickedFile!.path);
  }

  Future uploadImageToFirebase(File image) async {
    String filename = basename(image.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$filename');
    await firebaseStorageRef.putFile(image);

    return medias.add({'filename': filename}).then((value) {
      statusSave.value = 'success';
    }).catchError((err) {
      statusSave.value = 'error';
    });
  }
}
