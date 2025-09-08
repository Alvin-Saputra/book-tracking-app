import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

Future<File?> cropImage(File imageFile) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.green,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: true, // Kunci aspect ratio
        aspectRatioPresets: [
          // CropAspectRatioPreset.square, // Hanya square
          CropAspectRatioPresetCustom()
        ],
        initAspectRatio: CropAspectRatioPresetCustom(), // Set default ke square
        hideBottomControls: false,
        showCropGrid: true,
      ),
    ],
  );

  if (croppedFile != null) {
    return File(croppedFile.path);
  } else {
    return null;
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
