import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'customPickerText.dart';
import '/provider/imageEditProvider.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:image_editor/image_editor.dart';

Future<File?> saveCroppedImage(
    {required ExtendedImageEditorState state}) async {
  final Rect? cropRect = state.getCropRect();
  final EditActionDetails action = state.editAction!;

  final int rotateAngle = 0;
  final bool flipHorizontal = action.flipY;
  final bool flipVertical = action.flipY;
  final Uint8List img = state.rawImageData;

  final ImageEditorOption option = ImageEditorOption();

  if (action.needCrop) {
    option.addOption(ClipOption.fromRect(cropRect!));
  }

  if (action.needFlip) {
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
  }

  if (rotateAngle != 0) {
    option.addOption(RotateOption(rotateAngle));
  }
  final File? result = await ImageEditor.editImageAndGetFile(
    image: img,
    imageEditorOption: option,
  );

  return result;
}

Future pickGallery(
    BuildContext context, List<AssetEntity>? remainList, int maxAssets) async {
  List<AssetEntity>? assets = [];

  assets = await AssetPicker.pickAssets(
    context,
    pickerConfig: AssetPickerConfig(
      maxAssets: maxAssets,
      selectedAssets: remainList,
      gridCount: 3,
      pageSize: 81,
      requestType: RequestType.image,
      specialPickerType: SpecialPickerType.noPreview,
      sortPathDelegate: const CommonSortPathDelegate(),
      textDelegate: KoreanTextDelegate(),
    ),
  );
  // pickAssets()에서 뒤로가기를 누르면 null을 반환한다.
  if (assets == null) {
    Navigator.of(context).pop();
  } else {
    var defaultList = context.read<DefaultListNotifier>();
    var imageInfo = context.read<ImageInfoNotifier>();
    defaultList.changeList(assets);
    imageInfo.createImageInfo(defaultList.defaultList);
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final Widget label;
  final Clip clipBehavior;

  const CustomIconButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      clipBehavior: clipBehavior,
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all<TextStyle>(
          const TextStyle(color: Color(0xFFFFFFFF)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon,
          const SizedBox(height: 5.0),
          label,
        ],
      ),
    );
  }
}

class AspectRatioItem {
  AspectRatioItem({this.value, this.text});
  final String? text;
  final double? value;
}

class AspectRatioWidget extends StatelessWidget {
  const AspectRatioWidget(
      {this.aspectRatioS, this.aspectRatio, this.isSelected = false});
  final String? aspectRatioS;
  final double? aspectRatio;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: AspectRatioPainter(
          aspectRatio: aspectRatio,
          aspectRatioS: aspectRatioS,
          isSelected: isSelected),
    );
  }
}

class AspectRatioPainter extends CustomPainter {
  AspectRatioPainter(
      {this.aspectRatioS, this.aspectRatio, this.isSelected = false});
  final String? aspectRatioS;
  final double? aspectRatio;
  final bool isSelected;
  @override
  void paint(Canvas canvas, Size size) {
    final Color color = isSelected ? Colors.blue : Colors.grey;
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final double aspectRatioResult =
        (aspectRatio != null && aspectRatio! > 0.0) ? aspectRatio! : 1.0;
    canvas.drawRect(
        getDestinationRect(
            rect: const EdgeInsets.all(10.0).deflateRect(rect),
            inputSize: Size(aspectRatioResult * 100, 100.0),
            fit: BoxFit.contain),
        paint);

    final TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: aspectRatioS,
            style: TextStyle(
              color:
                  color.computeLuminance() < 0.5 ? Colors.white : Colors.black,
              fontSize: 16.0,
            )),
        textDirection: TextDirection.ltr,
        maxLines: 1);
    textPainter.layout(maxWidth: rect.width);

    textPainter.paint(
        canvas,
        rect.center -
            Offset(textPainter.width / 2.0, textPainter.height / 2.0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is AspectRatioPainter &&
        (oldDelegate.isSelected != isSelected ||
            oldDelegate.aspectRatioS != aspectRatioS ||
            oldDelegate.aspectRatio != aspectRatio);
  }

  Rect getDestinationRect({
    required Rect rect,
    required Size inputSize,
    BoxFit fit = BoxFit.contain,
  }) {
    Size size = rect.size;
    double scale = 1.0;
    if (size.width / size.height >= inputSize.width / inputSize.height) {
      scale = size.height / inputSize.height;
    } else {
      scale = size.width / inputSize.width;
    }
    double width = inputSize.width * scale;
    double height = inputSize.height * scale;
    double dx = rect.left + (size.width - width) / 2;
    double dy = rect.top + (size.height - height) / 2;
    return Rect.fromLTWH(dx, dy, width, height);
  }
}