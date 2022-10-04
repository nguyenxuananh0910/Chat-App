import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../theme/colors.dart';
import 'profile_bloc.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_text.dart';

import '../../../theme/strings.dart';
import '../../../services/auth.dart';
import '../../../services/database.dart';
import '../../../utils/get_color.dart';

class account extends StatefulWidget {
  const account({Key? key}) : super(key: key);

  @override
  State<account> createState() => _accountState();
}

class _accountState extends State<account> {
  final currentUser = Auth().currentUser!;

  final TextEditingController _nameController = TextEditingController();
  late ProfileBloc bloc;
  late Database database;
  String avatar = '';

  UploadTask? task;
  bool isUploadNewAvatar = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = currentUser.displayName ?? "";
    database = context.read<Database>();
    bloc = ProfileBloc(database: database);
    avatar = currentUser.photoURL ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> onPressChangeImage() async {
    var locationPermissionStatus = await Permission.storage.request();
    switch (locationPermissionStatus) {

      /// ok, had permission
      case PermissionStatus.granted:
        break;

      /// user denied
      case PermissionStatus.permanentlyDenied:
        bool? confirm = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Permission denied "),
            content: const Text(
                'Without this permission, the app is unable access to your gallery to select picture.Do you want to enable this permission'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel')),
              // The "Yes" button
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes')),
            ],
          ),
        );
        if (confirm!) {
          openAppSettings();
        }
        break;
      default:
        return;
    }

    /// Pick and handle file
    final fileSelection = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (fileSelection == null) return;

    final path = fileSelection.files.single.path!;
    final file = File(path);
    setState(() {
      task = bloc.uploadFile(file);
    });

    final snapshot = await task!;
    final urlDownload = await snapshot.ref.getDownloadURL();
    bloc.updateAvatar(urlDownload);
    currentUser.updatePhotoURL(urlDownload);
    Fluttertoast.showToast(msg: 'Update your avatar');
    setState(() {
      task = null;
      avatar = urlDownload;
    });
  }

  void _changeName() {
    FocusManager.instance.primaryFocus?.unfocus();
    final newName = _nameController.text.trim();
    bloc.updateName(newName);
    Fluttertoast.showToast(msg: 'Your name have been changed');
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildCameraOverlay() => Icon(
          Icons.camera_alt_outlined,
          size: 40,
          color: AppColor.primary.withOpacity(0.4),
        );
    Widget _buildUploadStatus(UploadTask uploadTask) {
      return StreamBuilder<TaskSnapshot>(
        stream: uploadTask.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;

            return progress != 1
                ? CircularProgressIndicator(value: progress)
                : _buildCameraOverlay();
          } else {
            return _buildCameraOverlay();
          }
        },
      );
    }

    Widget _buildAvatar() {
      return CupertinoButton(
        onPressed: isUploadNewAvatar ? null : onPressChangeImage,
        child: SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Avatar(avatar: avatar),
                ),
                Center(
                  child: task != null
                      ? _buildUploadStatus(task!)
                      : _buildCameraOverlay(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildNameEditing() {
      return TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(5),
        ),
        onChanged: (value) => setState(() {}),
      );
    }

    Widget _buildChangeNameButton() {
      bool isTrue = currentUser.displayName != _nameController.text &&
          _nameController.text.trim().isNotEmpty;
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: CustomButton(
          color: AppColor.primary,
          onPressed: isTrue ? _changeName : null,
          child: const CustomText(
            text: 'Change Name',
            textSize: 15,
            textColor: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios)),
                  Center(
                    child: _buildAvatar(),
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: 'Name: ',
                        textSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor:
                            getSuitableColor(AppColor.black, AppColor.white),
                      ),
                      Flexible(child: _buildNameEditing())
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildChangeNameButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({Key? key, required this.avatar}) : super(key: key);
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      clipBehavior: Clip.hardEdge,
      child: avatar.isNotEmpty
          ? Image.network(
              avatar,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                );
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
