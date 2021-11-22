import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart' hide FileImage;
import '/provider/imageEditProvider.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var _cropLayerPainter;
  late GestureNotifier gestured;
  late CurrentIndexNotifier currentIndex;
  var imageFileNotifier;
  var imageEditorKeyNotifier;

  @override
  void initState() {
    super.initState();
    _cropLayerPainter = const EditorCropLayerPainter();
  }

  @override
  Widget build(BuildContext context) {
    print("editScreen Build!");
    gestured = context.watch<GestureNotifier>();
    currentIndex = context.watch<CurrentIndexNotifier>();
    imageFileNotifier =
        context.select((ImageInfoNotifier item) => item.imageFileList);
    imageEditorKeyNotifier =
        context.select((ImageInfoNotifier item) => item.imageEditorKeyList);

    return Expanded(
      child: Container(
        color: const Color(0xFF303030),
        child: ExtendedImage.file(
          imageFileNotifier[currentIndex.currentIndex],
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          enableLoadState: true,
          extendedImageEditorKey:
              imageEditorKeyNotifier[currentIndex.currentIndex],
          initEditorConfigHandler: (ExtendedImageState? state) {
            return EditorConfig(
                maxScale: 7.0,
                editorMaskColorHandler:
                    (BuildContext context, bool pointerDown) {
                  return Colors.black.withOpacity(pointerDown ? 0.6 : 0.8);
                },
                cropRectPadding: const EdgeInsets.all(10.0),
                cropLayerPainter: _cropLayerPainter!,
                initCropRectType: InitCropRectType.imageRect,
                cropAspectRatio:
                    context.read<AspectRatiosNotifier>().aspectRatio!.value,
                editActionDetailsIsChanged: (_) {
                  if (!gestured.gestured) {
                    gestured.changeGesture(true);
                  }
                });
          },
          cacheRawData: true,
        ),
      ),
    );
  }
}