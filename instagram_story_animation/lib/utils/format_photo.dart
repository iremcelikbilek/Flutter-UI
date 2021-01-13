import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class FormatPhoto with ChangeNotifier{
  MemoryImage memoryImageFromBase64String(String base64String) {
    return MemoryImage(
      base64Decode(base64String),
    );
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  String base64String(Uint8List data) {
    notifyListeners();
    return base64Encode(data);
  }
}
