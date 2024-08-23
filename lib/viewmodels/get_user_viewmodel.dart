import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/db_helper.dart';
import '../models/user.dart';
import '../views/auth/login_screen.dart';

class GetUserViewModel extends ChangeNotifier {
  final db = DatabaseHelper();
  User? user;
  var picker = ImagePicker();
  File? fileImage;
  notifyListeners();

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId != null) {
      User? user = await db.getUserById(userId);
      if (user != null) {

          user = user;
          fileImage = user.imagePath != null ? File(user.imagePath!) : null;
notifyListeners();
      } else {
        print("User not found.");
        notifyListeners();
      }
    } else {
      print("User ID not found in SharedPreferences.");
      notifyListeners();
    }
  }
  Future<void> saveImageToDatabase(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId != null) {
      await db.updateProfileImage(userId, imagePath);
      notifyListeners();
    }
  }
  Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');  // Remove the saved user ID

    // Navigate to the login screen (replace `LoginScreen` with your actual login screen)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }


  Future<void> imageFromCamera() async {
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      await cropImageFile(File(image.path));
      notifyListeners();
    }
  }

  Future<void> imageFromGallery() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      await cropImageFile(File(image.path));
      notifyListeners();
    }
  }

  Future<void> cropImageFile(File imageFile) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
      ],
    );

    if (croppedImage != null) {

        fileImage = File(croppedImage.path);

      await saveImageToDatabase(croppedImage.path);
      notifyListeners();
    }
  }
  Future<void> deleteImage(BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    await db.deleteProfileImage(userId!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image deleted')),
    );
    notifyListeners();
  }
}
