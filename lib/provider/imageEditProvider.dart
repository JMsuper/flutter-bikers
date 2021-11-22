import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart' hide FileImage;
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '/shared/imageEdit/editImagePageElement.dart';
import 'dart:io';

class ImageInfoNotifier extends ChangeNotifier {
  List<File> imageFileList = [];
  List<GlobalKey<ExtendedImageEditorState>> imageEditorKeyList = [];
  bool isListNotEmpty = false;

  Future createImageInfo(List<AssetEntity> assetlist) async {
    imageFileList = [];
    imageEditorKeyList = [];
    await Future.forEach(assetlist, (AssetEntity element) async {
      File file = await element.file as File;
      imageFileList.add(file);
      imageEditorKeyList.add(GlobalKey<ExtendedImageEditorState>());
    });
    isListNotEmpty = true;
    notifyListeners();
  }

  void updateImageInfo(int index, File file) {
    imageFileList = List.from(imageFileList);
    imageEditorKeyList = List.from(imageEditorKeyList);
    imageFileList[index] = file;
    imageEditorKeyList[index] = GlobalKey<ExtendedImageEditorState>();
    notifyListeners();
  }

  void imageInfoNotifierReset() {
    imageFileList = [];
    imageEditorKeyList = [];
    isListNotEmpty = false;
    notifyListeners();
  }

  void flip(int index) {
    imageEditorKeyList = List.from(imageEditorKeyList);
    imageEditorKeyList[index].currentState!.flip();
    notifyListeners();
  }

  void rotateLeft(int index) {
    imageEditorKeyList = List.from(imageEditorKeyList);
    imageEditorKeyList[index].currentState!.rotate(right: false);
    notifyListeners();
  }

  void rotateRight(int index) {
    imageEditorKeyList = List.from(imageEditorKeyList);
    imageEditorKeyList[index].currentState!.rotate(right: true);
    notifyListeners();
  }

  void reset(int index) {
    imageEditorKeyList = List.from(imageEditorKeyList);
    imageEditorKeyList[index].currentState!.reset();
    notifyListeners();
  }
}

class GestureNotifier extends ChangeNotifier {
  bool gestured = false;

  void changeGesture(bool value) {
    gestured = value;
    notifyListeners();
  }

  void gestureNotifierReset() {
    gestured = false;
    notifyListeners();
  }
}

class CurrentIndexNotifier extends ChangeNotifier {
  int currentIndex = 0;

  void changeCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void currentIndexNotifierReset() {
    currentIndex = 0;
    notifyListeners();
  }
}

class AspectRatiosNotifier extends ChangeNotifier {
  final List<AspectRatioItem> aspectRatios = <AspectRatioItem>[
    AspectRatioItem(text: 'custom', value: CropAspectRatios.custom),
    AspectRatioItem(text: '원본', value: CropAspectRatios.original),
    AspectRatioItem(text: '1*1', value: CropAspectRatios.ratio1_1),
    AspectRatioItem(text: '4*3', value: CropAspectRatios.ratio4_3),
    AspectRatioItem(text: '3*4', value: CropAspectRatios.ratio3_4),
    AspectRatioItem(text: '16*9', value: CropAspectRatios.ratio16_9),
    AspectRatioItem(text: '9*16', value: CropAspectRatios.ratio9_16)
  ];
  AspectRatioItem? aspectRatio;
  AspectRatiosNotifier() {
    aspectRatio = aspectRatios.first;
  }

  void changeAspectRatio(AspectRatioItem item) {
    aspectRatio = item;
    notifyListeners();
  }

  void aspectRatiosNotifierReset() {
    aspectRatio = aspectRatios.first;
    notifyListeners();
  }
}

class DefaultListNotifier extends ChangeNotifier {
  List<AssetEntity> defaultList = [];

  void changeList(List<AssetEntity> list) {
    defaultList = list;
    notifyListeners();
  }

  void defaultListNotifierReset() {
    defaultList = [];
    notifyListeners();
  }
}