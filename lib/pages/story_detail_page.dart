import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/story_detail_provider.dart';
import 'package:story_app/widget/map.dart';

class StoryDetailsPage extends StatefulWidget {
  final String storyId;

  const StoryDetailsPage({super.key, required this.storyId});

  @override
  State<StoryDetailsPage> createState() => _StoryDetailsPageState();
}

class _StoryDetailsPageState extends State<StoryDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final storyDetailProvider =
          Provider.of<StoryDetailProvider>(context, listen: false);
      await storyDetailProvider.getStories(widget.storyId);
    });
  }

  StoryDetailProvider? _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<StoryDetailProvider>(context);
  }

  @override
  void dispose() {
    _provider?.resetValues();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story App"),
      ),
      body: Center(child: Consumer<StoryDetailProvider>(
        builder: (context, value, child) {
          if (value.isLoadingDetail) {
            return const Center(child: CircularProgressIndicator());
          }
          if (value.isLoaded) {
            return ListView(
              children: [
                Image.network(
                  value.story!.photoUrl,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 30,
                ),
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Diupload oleh: ${value.story!.name}"),
                      Text("Pada: ${value.story!.createdAt}")
                    ],
                  ),
                  subtitle: Text(value.story!.description),
                ),
                const SizedBox(
                  height: 16,
                ),
                if (value.story!.lat != null && value.story!.lon != null) ...[
                  const Text("Posting from:"),
                  StoryMapWidget(
                      key:
                          ValueKey("${value.story!.lat!}-${value.story!.lon!}"),
                      position: LatLng(value.story!.lat!.toDouble(),
                          value.story!.lon!.toDouble()))
                ]
              ],
            );
          }
          return const Text("Gagal memuat data");
        },
      )),
    );
  }
}
