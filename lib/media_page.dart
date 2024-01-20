import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_bionic_app_2/controller/media_controller.dart';

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    MediaController mediaController = Get.put(MediaController());

    Future<void> showSelectionDialog(BuildContext _) {
      return showDialog(
          context: context,
          builder: (BuildContext _) {
            return AlertDialog(
              title: const Text("Pilih sumber foto"),
              content: SingleChildScrollView(
                  child: ListBody(
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('Gallery', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    onTap: () {
                      mediaController.imageSource('gallery').then((value) {
                        mediaController.uploadImageToFirebase(value);
                      });
                      Get.back();
                    },
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('Camera', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    onTap: () {
                      // _imageSource('Camera');
                      // Get.back();
                    },
                  ),
                ],
              )),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Page'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showSelectionDialog(context);
          },
          child: const Icon(Icons.add)),
    );
  }
}
