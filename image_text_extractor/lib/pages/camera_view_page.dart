import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_text_extractor/pages/display_picture_pre_extration_page.dart';
import 'package:image_text_extractor/utilities/camera_utils.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({super.key});

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();

    _cameraController = CameraController(
      CameraUtils.firstCamera!,
      ResolutionPreset.medium,
    );

    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera View'),
      ),
      body: FutureBuilder<void>(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeCameraControllerFuture;
            final image = await _cameraController.takePicture();
            if (!context.mounted) return;

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPicturePreExtractionPage(imagePath: image.path),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        tooltip: 'Take a picture',
        child: const Icon(Icons.camera),
      ),
    );
  }
}
