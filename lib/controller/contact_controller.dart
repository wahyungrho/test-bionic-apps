import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  CollectionReference contacts =
      FirebaseFirestore.instance.collection('contacts');
  RxString statusSave = ''.obs;

  Future<void> addContact() {
    return contacts.add({
      'contact_name': nameController.text,
      'phone': phoneController.text
    }).then((value) {
      statusSave.value = 'success';
      nameController.clear();
      phoneController.clear();
    }).catchError((err) {
      statusSave.value = 'error';
    });
  }
}
