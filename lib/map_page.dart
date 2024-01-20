import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_bionic_app_2/controller/map_controller.dart';
import 'package:test_bionic_app_2/theme.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    MapController mapController = Get.put(MapController());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await mapController.determinePosition().then((value) {
        if (!value.isMocked) {
          mapController.getAddressFromLatLong(value);
        } else {
          debugPrint(
              'Anda terdeteksi menggunakan Fake GPS, tidak dapat melakukan Absensi.');
        }
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Page"),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Center(
            child: Obx(() => (mapController.isLoading.value)
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text('street : ${mapController.street.value}'),
                        Text(
                            'subLocality : ${mapController.subLocality.value}'),
                        Text('locality : ${mapController.locality.value}'),
                        Text(
                            'subAdministration : ${mapController.subAdministration.value}'),
                        Text(
                            'administrative : ${mapController.administrative.value}'),
                        Text('postalCode : ${mapController.postalCode.value}'),
                        Text('country : ${mapController.country.value}'),
                        const SizedBox(height: defaultMargin),
                        Center(
                          child: ElevatedButton.icon(
                              icon: const Icon(Icons.share),
                              onPressed: () async {
                                mapController.shareAddress(
                                    '${mapController.street.value}, ${mapController.subLocality.value}, ${mapController.locality.value}, ${mapController.subAdministration.value}, ${mapController.administrative.value}, ${mapController.postalCode.value}, ${mapController.country.value}');
                              },
                              label: const Text('Share')),
                        )
                      ])),
          )),
    );
  }
}
