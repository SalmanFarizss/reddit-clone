import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}
Future<FilePickerResult?>selectImage() async {
  final img=await FilePicker.platform.pickFiles(type: FileType.image );
  return img;
}
