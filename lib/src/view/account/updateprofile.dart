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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
    _emailController.text = currentUser.email ?? "";
    _passwordController.text = "123456";
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

  void _changeProfile() {
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
          color: AppColor.primary.withOpacity(0.8),
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

    Widget _editLine(type) {
      final typeController;
      switch (type.toString().toLowerCase()) {
        case "name":
          typeController = _nameController;
          break;
        case "email":
          typeController = _emailController;
          break;
        case "password":
          typeController = _passwordController;
          break;
        default:
          typeController = "NULL";
          break;
      }
      return TextField(
        controller: typeController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
        ),
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
        onChanged: (value) => setState(() {}),
      );
    }

    Widget _buildSaveButton() {
      bool isTrue = currentUser.displayName != _nameController.text &&
          _nameController.text.trim().isNotEmpty;
      return Container(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          width: 100,
          height: 50,
          child: ElevatedButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColor.purpleApp,
            ),
            onPressed: isTrue ? _changeProfile : null,
            child: const CustomText(
              text: 'Save',
              textSize: 20,
              textColor: AppColor.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      );
    }

    Widget _buildEditing(string) {
      Widget functionString;
      switch (string) {
        case "Name":
          functionString = _editLine("name");
          break;
        case "Password":
          functionString = _editLine("password");
          break;
        case "Email":
          functionString = _editLine("email");
          break;
        default:
          functionString = const Text("NULL Info");
          break;
      }
      return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  child: Text('$string: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: getSuitableColor(
                            AppColor.lightGray, AppColor.white),
                      ))),
              functionString,
            ],
          ));
    }

    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
           child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(children: const [
                    Icon(Icons.arrow_back_ios),
                    Text("Back",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        )),
                  ]),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: const Text("Edit Profile",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                          color: AppColor.purpleApp,
                        ))),
                Center(
                  child: _buildAvatar(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 30
                  ),
                  child: Column(
                    children: [
                      _buildEditing("Name"),
                      _buildEditing("Email"),
                      _buildEditing("Password"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildSaveButton(),
                const SizedBox(height: 20),
              ],
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
              width: 200,
              height: 200,
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
