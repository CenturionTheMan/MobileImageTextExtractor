import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraUtils {
  static CameraDescription? firstCamera;

  static void initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    firstCamera = cameras.first;
  }
}
