import 'package:flutter/material.dart';
import 'dart:async';
import 'package:extended_image/extended_image.dart' hide File;
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'customPickerText.dart';
import 'dart:io';
import 'editImagePageElement.dart';
import 'package:bikers/shared/imageCompress.dart';

class EditImageCamaraPage extends StatefulWidget {
  const EditImageCamaraPage({this.editType});
  final editType;

  @override
  _EditImageCameraPageState createState() => _EditImageCameraPageState();
}

class _EditImageCameraPageState extends State<EditImageCamaraPage> {
  StreamController<Map<String, dynamic>> streamController =
      StreamController<Map<String, dynamic>>();

  final List<AspectRatioItem> _aspectRatios = <AspectRatioItem>[
    AspectRatioItem(text: 'custom', value: CropAspectRatios.custom),
    AspectRatioItem(text: '원본', value: CropAspectRatios.original),
    AspectRatioItem(text: '1*1', value: CropAspectRatios.ratio1_1),
    AspectRatioItem(text: '4*3', value: CropAspectRatios.ratio4_3),
    AspectRatioItem(text: '3*4', value: CropAspectRatios.ratio3_4),
    AspectRatioItem(text: '16*9', value: CropAspectRatios.ratio16_9),
    AspectRatioItem(text: '9*16', value: CropAspectRatios.ratio9_16)
  ];

  AspectRatioItem? _aspectRatio;
  EditorCropLayerPainter? _cropLayerPainter;

  bool gestureChanged = false;

  @override
  void initState() {
    super.initState();
    _aspectRatio = _aspectRatios.first;
    _cropLayerPainter = const EditorCropLayerPainter();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      AssetEntity? image;
      image = await CameraPicker.pickFromCamera(context,
          textDelegate: KoreanCameraPickerTextDelegate());
      if (image == null) {
        Navigator.of(context).pop();
      } else {
        File file = await image.file as File;
        String imageName = file.path.split('/').last;
        var compressedFile =
            await ImageCompress.compressAndGetFile(file, imageName, 30);
        streamController.add({
          "file": compressedFile,
          "editorKey": GlobalKey<ExtendedImageEditorState>()
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }

  Future pickCamera(BuildContext context) async {
    AssetEntity? image;
    image = await CameraPicker.pickFromCamera(context,
        textDelegate: KoreanCameraPickerTextDelegate());
    if (image == null) {
      Navigator.of(context).pop();
    } else {
      File file = await image.file as File;
      String imageName = file.path.split('/').last;
      var compressedFile =
          await ImageCompress.compressAndGetFile(file, imageName, 30);
      streamController.add({
        "file": compressedFile,
        "editorKey": GlobalKey<ExtendedImageEditorState>()
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: streamController.stream,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SafeArea(
                child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(
                      Icons.keyboard_backspace,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      pickCamera(context);
                    }),
                centerTitle: true,
                elevation: 10,
                toolbarHeight: 45,
                backgroundColor: Colors.grey[900],
                actions: [
                  TextButton(
                      onPressed: () async {
                        File? image = await saveCroppedImage(
                            state: snapshot.data["editorKey"].currentState);
                        Navigator.of(context).pop(image);
                      },
                      child: Text(
                        "완료",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              body: Column(children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[850],
                    child: ExtendedImage.file(
                      snapshot.data["file"],
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.editor,
                      enableLoadState: true,
                      extendedImageEditorKey: snapshot.data["editorKey"],
                      initEditorConfigHandler: (ExtendedImageState? state) {
                        return EditorConfig(
                            maxScale: 7.0,
                            editorMaskColorHandler:
                                (BuildContext context, bool pointerDown) {
                              return Colors.black
                                  .withAlpha(pointerDown ? 153 : 204);
                            },
                            cornerColor: Colors.grey[700],
                            cornerSize: Size(30, 3.5),
                            cropRectPadding: const EdgeInsets.all(10.0),
                            cropLayerPainter: _cropLayerPainter!,
                            initCropRectType: InitCropRectType.imageRect,
                            cropAspectRatio: _aspectRatio!.value,
                            editActionDetailsIsChanged: (_) {
                              if (!gestureChanged) {
                                setState(() {
                                  gestureChanged = true;
                                });
                              }
                            });
                      },
                      cacheRawData: true,
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                )
              ]),
              bottomNavigationBar: BottomAppBar(
                color: Colors.black,
                shape: const CircularNotchedRectangle(),
                child: ButtonTheme(
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CustomIconButton(
                        icon: const Icon(
                          Icons.crop,
                          color: Colors.white,
                        ),
                        label: const Text(
                          '편집창',
                          style: TextStyle(fontSize: 10.0, color: Colors.white),
                        ),
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Column(
                                  children: <Widget>[
                                    const Expanded(
                                      child: const SizedBox(),
                                    ),
                                    SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.all(20.0),
                                        itemBuilder: (_, int index) {
                                          final AspectRatioItem item =
                                              _aspectRatios[index];
                                          return GestureDetector(
                                            child: AspectRatioWidget(
                                              aspectRatio: item.value,
                                              aspectRatioS: item.text,
                                              isSelected: item == _aspectRatio,
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                _aspectRatio = item;
                                              });
                                            },
                                          );
                                        },
                                        itemCount: _aspectRatios.length,
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                      CustomIconButton(
                        icon: const Icon(
                          Icons.flip,
                          color: Colors.white,
                        ),
                        label: const Text(
                          '반전',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          snapshot.data["editorKey"].currentState!.flip();
                        },
                      ),
                      CustomIconButton(
                        icon: const Icon(
                          Icons.rotate_left,
                          color: Colors.white,
                        ),
                        label: const Text(
                          '왼쪽',
                          style: TextStyle(
                            fontSize: 8.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          snapshot.data["editorKey"].currentState!
                              .rotate(right: false);
                        },
                      ),
                      CustomIconButton(
                        icon: const Icon(
                          Icons.rotate_right,
                          color: Colors.white,
                        ),
                        label: const Text(
                          '오른쪽',
                          style: TextStyle(
                            fontSize: 8.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          snapshot.data["editorKey"].currentState!
                              .rotate(right: true);
                        },
                      ),
                      CustomIconButton(
                        icon: const Icon(
                          Icons.restore,
                          color: Colors.white,
                        ),
                        label: const Text(
                          '되돌리기',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          snapshot.data["editorKey"].currentState!.reset();
                          setState(() {
                            _aspectRatio = _aspectRatios[0];
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ));
          }
        });
  }
}