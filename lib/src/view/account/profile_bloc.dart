import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../../../services/auth.dart';
import '../../../services/database.dart';
import '../../../services/storage_database.dart';

class ProfileBloc {
  final Database database;

  ProfileBloc({required this.database});

  UploadTask? uploadFile(File file) {
    final currentUser = Auth().currentUser!;
    final fileName = basename(file.path);
    final destination = 'avatar/${currentUser.uid}/$fileName';
    return StorageDatabase.uploadFile(destination, file);
  }

  Future<void> updateAvatar(String url) async {
    final currentUser = Auth().currentUser!;
    await currentUser.updatePhotoURL(url);
    database.updateUserAvatar(url: url);
  }

  void updateName(String name) {
    final currentUser = Auth().currentUser!;
    currentUser.updateDisplayName(name);
    database.updateUserName(newName: name);
  }
}
