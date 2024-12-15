import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<String> requestImageToText(String imagePath, String language) async {
  http.Response resp =
      await http.post(Uri.parse('https://api.ocr.space/parse/image'), body: {
    "apikey": "K86072569888957",
    "base64Image": _imageToBase64String(imagePath),
    "language": language
  });

  String text = "";
  List pages = json.decode(resp.body)["ParsedResults"];
  for (var page in pages) {
    String pageText = page["ParsedText"];
    text += pageText.replaceAll("\n", "");
  }
  return text;
}

String _imageToBase64String(String imagePath) {
  List<int> bytes = File(imagePath).readAsBytesSync();
  String base64Image = base64Encode(bytes);
  return "data:image/jpg;base64,$base64Image";
}

Future<String> requestImageToTextMlKit(String imagePath) async {
  final inputImage = InputImage.fromFilePath(imagePath);
  final textRecognizer = TextRecognizer();
  final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);
  String text = recognizedText.text;
  textRecognizer.close();
  return text;
}
