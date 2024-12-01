import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;

Future<String> requestImageToText(String imagePath, String language) async {
  http.Response resp = await http.post(
      Uri.parse('https://api.ocr.space/parse/image'),
      body: {
        "apikey": "K86072569888957",
        "base64Image": _imageToBase64String(imagePath),
        "language": language
      }
  );

  String text = "";
  List pages = json.decode(resp.body)["ParsedResults"];
  for (var page in pages) {
    String pageText = page["ParsedText"];
    text += pageText.replaceAll("\n\r", "");
  }
  return text;
}

String _imageToBase64String(String imagePath) {
  List<int> bytes = File(imagePath).readAsBytesSync();
  String base64Image = base64Encode(bytes);
  return "data:image/jpg;base64,$base64Image";
}