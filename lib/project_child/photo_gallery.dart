import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({super.key});
  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  final _picker = ImagePicker();
  final _images = <File>[];

  Future<void> _pick() async {
    await Permission.camera.request();
    final x = await _picker.pickImage(source: ImageSource.camera);
    if (x != null) setState(() => _images.add(File(x.path)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
        itemCount: _images.length,
        itemBuilder: (_, i) => Image.file(_images[i], fit: BoxFit.cover),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _pick, child: const Icon(Icons.camera_alt)),
    );
  }
}
