import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_sample/utils/user_simple_preferences.dart';
import 'package:shared_sample/widget/button_widget.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  File? imageFile;
  List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {
    Future.value(setImages());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: imagePaths.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Image.file(
                      File(
                        imagePaths[index],
                      ),
                    ),
                    onLongPress: () {
                      setState(() {
                        imagePaths.removeAt(index);
                        saveImagePaths();
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildGalleryButton(),
            )
          ],
        ),
      ),
    );
  }

  Future saveImagePaths() async {
    if (imagePaths.isNotEmpty) {
      await UserSimplePreferences.saveImageList(imagePaths);
      setState(() {});
    }
  }

  Future setImages() async {
    final List<String>? savedImagePaths = UserSimplePreferences.getImageList();

    if (savedImagePaths != null) {
      imagePaths = savedImagePaths;
      setState(() {});
    }
  }

  Widget buildGalleryButton() => ButtonWidget(
        text: 'Gallery',
        onClicked: () async {
          final ImagePicker picker = ImagePicker();
          final pickerFile =
              await picker.pickImage(source: ImageSource.gallery);
          if (pickerFile != null) {
            imageFile = File(pickerFile.path);
            imagePaths.add(imageFile!.path);
            await saveImagePaths();
            setState(() {});
          }
        },
      );
}
