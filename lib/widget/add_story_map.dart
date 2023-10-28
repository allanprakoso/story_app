import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/map_provider.dart';

class AddStoryMapWidget extends StatefulWidget {
  const AddStoryMapWidget({super.key});

  @override
  State<AddStoryMapWidget> createState() => _AddStoryMapWidgetState();
}

class _AddStoryMapWidgetState extends State<AddStoryMapWidget> {
  late GoogleMapController mapController;
  final double zoom = 18;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final storyListProvider =
          Provider.of<MapProvider>(context, listen: false);
      await storyListProvider.getCurrentPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Consumer<MapProvider>(builder: (context, provider, widget) {
            return GoogleMap(
              markers: provider.markers,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: provider.position!, zoom: 18),
              onMapCreated: (controller) {
                final provider = context.read<MapProvider>();

                provider.getCurrentPosition();
                provider.mapController = controller;
              },
              onLongPress: (LatLng latLng) {
                final provider = context.read<MapProvider>();
                provider.onLongPress(latLng);
              },
            );
          }),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.small(
              child: const Icon(Icons.my_location),
              onPressed: () async {
                final provider = context.read<MapProvider>();
                provider.getCurrentPosition();
              },
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  child: const Icon(Icons.zoom_in),
                  onPressed: () async {
                    final provider = context.read<MapProvider>();
                    provider.mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                ),
                FloatingActionButton.small(
                  child: const Icon(Icons.zoom_out),
                  onPressed: () {
                    final provider = context.read<MapProvider>();
                    provider.mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
