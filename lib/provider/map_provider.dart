import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class MapProvider extends ChangeNotifier {
  LatLng? position = const LatLng(0, 0);

  late GoogleMapController mapController;

  final Set<Marker> _marker = {};

  Set<Marker> get markers => _marker;
  geo.Placemark? placemark;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  set setMapController(GoogleMapController value) {
    mapController = value;
  }

  Future<void> getCurrentPosition() async {
    final Location location = Location();
    late bool serviceEnabled;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    print(serviceEnabled);
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }

    bool isGranted = await getPermission();
    if (!isGranted) {
      print("Location permission is denied, please update your permission");
      return;
    }
    locationData = await location.getLocation();

    final info = await geo.placemarkFromCoordinates(
      locationData.latitude!,
      locationData.longitude!,
    );
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    defineMarker(LatLng(locationData.latitude!, locationData.longitude!),
        street, address);

    notifyListeners();
  }

  Future<bool> getPermission() async {
    final Location location = Location();
    late PermissionStatus permissionStatus;

    permissionStatus = await location.hasPermission();

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return false;
      }
    }

    return permissionStatus == PermissionStatus.granted;
  }

  void defineMarker(LatLng latLng, String street, String address) {
    _marker.clear();
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    _marker.add(marker);
    position = LatLng(latLng.latitude, latLng.longitude);

    notifyListeners();

    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  Future<void> onLongPress(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    defineMarker(latLng, street, address);
    position = LatLng(latLng.latitude, latLng.longitude);

    notifyListeners();

    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }
}
