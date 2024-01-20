import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_bionic_app_2/controller/contact_controller.dart';
import 'package:test_bionic_app_2/theme.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> contactStream =
        FirebaseFirestore.instance.collection('contacts').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: contactStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Contact Page'),
          ),
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Column(
                children: [
                  ListTile(
                    title: Text(data['contact_name']),
                    subtitle: Text(data['phone']),
                  ),
                  const Divider(height: 0, color: greyColor)
                ],
              );
            }).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FormContactPage())),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class FormContactPage extends StatelessWidget {
  const FormContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    ContactController contactController = Get.put(ContactController());

    Widget textEditing(
            String hintText, TextEditingController textEditingController,
            {TextInputType? keyboarType}) =>
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(bottom: defaultMargin),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: greyColor)),
          child: Center(
            child: TextFormField(
                controller: textEditingController,
                keyboardType: keyboarType,
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                )),
          ),
        );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Form Page'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(defaultMargin),
          children: [
            textEditing('Contact Name', contactController.nameController),
            textEditing('Phone Number', contactController.phoneController,
                keyboarType: const TextInputType.numberWithOptions()),
            ElevatedButton(
                onPressed: () async {
                  await contactController.addContact();
                  if (contactController.statusSave.value == 'success') {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Save contact successfully')));
                    Get.back();
                  }
                },
                child: const Text('Save'))
          ],
        ));
  }
}
