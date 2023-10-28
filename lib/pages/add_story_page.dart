import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/map_provider.dart';
import 'package:story_app/widget/add_story_map.dart';

class AddStoryPage extends StatefulWidget {
  final VoidCallback onSuccessAddStory;

  const AddStoryPage({super.key, required this.onSuccessAddStory});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  File? selectedImage;

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add Story")),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Form(
                key: formKey,
                child: ListView(children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _selectImage(),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (selectedImage != null)
                            Opacity(
                              opacity: 0.8,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                  child: Image.file(
                                    selectedImage!,
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          selectedImage != null
                              ? const SizedBox()
                              : Text(
                                  "Select Image",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Plase enter description!';
                      }
                      return null;
                    },
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                      height: 300,
                      child: Consumer<MapProvider>(
                          builder: (context, value, child) {
                        if (value.position != null) {
                          return const AddStoryMapWidget();
                        } else {
                          return const Text("Location unknown");
                        }
                      })),
                  ElevatedButton(
                    onPressed: () => _onUploadPressed(),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text("Upload")],
                    ),
                  )
                ]))));
  }

  _onUploadPressed() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (formKey.currentState?.validate() == true && selectedImage != null) {
      final result = await context.read<AddStoryProvider>().addStory(
            description: descriptionController.text,
            imagePath: selectedImage!,
            lat: context.read<MapProvider>().position?.latitude,
            lon: context.read<MapProvider>().position?.longitude,
          );
      if (result) {
        widget.onSuccessAddStory();
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text(
                "Failed to add story make sure must be a valid image file, max size 1MB"),
          ),
        );
      }
    }
  }

  Future<void> _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }
}
