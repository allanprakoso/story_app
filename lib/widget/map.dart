import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;

class StoryMapWidget extends StatefulWidget {
  final LatLng position;

  const StoryMapWidget({
    Key? key,
    required this.position,
  }) : super(key: key);

  @override
  State<StoryMapWidget> createState() => _StoryMapWidgetState();
}

class _StoryMapWidgetState extends State<StoryMapWidget> {
  GoogleMapController? mapController;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _defineMarker();
  }

  @override
  void didUpdateWidget(covariant StoryMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) {
      _defineMarker();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: GoogleMap(
            markers: markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            zoomGesturesEnabled: false,
            initialCameraPosition:
                CameraPosition(target: widget.position, zoom: 18),
            onMapCreated: (controller) {
              mapController = controller;
            },
          ),
        ),
      ],
    );
  }

  _defineMarker() async {
    final info = await geo.placemarkFromCoordinates(
      widget.position.latitude,
      widget.position.longitude,
    );
    if (info.isNotEmpty) {
      final place = info[0];
      final street = place.street ?? ''; // Added null check
      final address =
          '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      final marker = Marker(
        markerId: MarkerId(address.toString()),
        position: widget.position,
        infoWindow: InfoWindow(
          title: street,
          snippet: address,
        ),
        onTap: () {
          mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(widget.position, 18),
          );
        },
      );
      print("Rebuilding StoryMapWidget with position: ${widget.position}");

      setState(() {
        markers.clear();
        markers.add(marker);
      });
    }
  }
}
