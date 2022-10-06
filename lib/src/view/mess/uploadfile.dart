import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../../utils/kind_of_file.dart';

File? imageFile;
File? file;
PlatformFile? pickfile;
UploadTask? uploadTask;
Future getCameraImages() async {
  ImagePicker _picker = ImagePicker();
  await _picker.pickImage(source: ImageSource.camera).then((xFile) {
    if (xFile != null) {
      imageFile = File(xFile.path);
    }
  });
}
