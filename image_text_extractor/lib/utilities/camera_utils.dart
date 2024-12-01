import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraUtils {
  static List<CameraDescription> cameras = [];

  static void initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  }
}
