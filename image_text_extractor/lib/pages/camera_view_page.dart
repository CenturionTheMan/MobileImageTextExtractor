
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_text_extractor/pages/display_picture_pre_extration_page.dart';
import 'package:image_text_extractor/utilities/camera_utils.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/header_bar.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({super.key});

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;
  int currentCameraIndex = 0;

  @override
  void initState() {
    super.initState();

    _cameraController = CameraController(
      CameraUtils.cameras[currentCameraIndex],
      ResolutionPreset.veryHigh,
    );

    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void changeCamera() async {
    setState(() {
      int maxCameras = CameraUtils.cameras.length;
      currentCameraIndex = (currentCameraIndex + 1) % maxCameras;
      _cameraController = CameraController(
          CameraUtils.cameras[currentCameraIndex],
          ResolutionPreset.veryHigh
      );
      _initializeCameraControllerFuture = _cameraController.initialize();
    });
  }
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPicturePreExtractionPage(imagePath: pickedFile.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const HeaderBar(title: 'Camera View'),
              Expanded(
                child: FutureBuilder<void>(
                  future: _initializeCameraControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_cameraController);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: "switchCameraButton",
            onPressed: () { changeCamera(); },
            tooltip: "Switch camera",
            child: const Icon(Icons.switch_camera_outlined),
          ),
          const SizedBox(width: 5),
          FloatingActionButton(
            heroTag: "takePhotoBtn",
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
          const SizedBox(width: 5),

          FloatingActionButton(
            heroTag: "pickImageBtn",
            onPressed: pickImageFromGallery,
            tooltip: 'Pick image from gallery',
            child: const Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}
