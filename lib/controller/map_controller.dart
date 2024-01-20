import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as location;
import 'package:share_plus/share_plus.dart';

class MapController extends GetxController {
  RxBool isLoading = false.obs;
  RxString street = "".obs,
      subLocality = "".obs,
      locality = "".obs,
      subAdministration = "".obs,
      administrative = "".obs,
      postalCode = "".obs,
      country = "".obs;

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    isLoading.value = true;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      serviceEnabled = await location.Location().requestService();
      if (!serviceEnabled) {
        // Location services are not enabled.
        isLoading.value = false;
        Geolocator.openLocationSettings();
        return Future.error('Location services are disabled.');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        // show dialog function
        // showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: Text('Perizinan ditolak'),
        //         content: Text(
        //             'Aplikasi ini membutuhkan izin lokasi untuk mengambil lokasi anda'),
        //         actions: <Widget>[
        //           TextButton(
        //             child: Text('Pengaturan'),
        //             onPressed: () {
        //               Navigator.pop(context);
        //               Navigator.pop(context);
        //               Geolocator.openAppSettings();
        //             },
        //           ),
        //         ],
        //       );
        //     });

        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void getAddressFromLatLong(Position lastPosition) async {
    isLoading.value = true;
    List<Placemark> placemarks = await placemarkFromCoordinates(
        lastPosition.latitude, lastPosition.longitude);

    Placemark place = placemarks[0];

    street.value = '${place.street}';
    subLocality.value = '${place.subLocality}';
    locality.value = '${place.locality}';
    subAdministration.value = '${place.subAdministrativeArea}';
    administrative.value = '${place.administrativeArea}';
    postalCode.value = '${place.postalCode}';
    country.value = '${place.country}';
    isLoading.value = false;
  }

  void shareAddress(String address) async {
    await Share.share(address);
  }
}
