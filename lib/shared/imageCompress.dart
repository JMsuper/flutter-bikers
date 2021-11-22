import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ImageCompress {
  static Future<File> compressAndGetFile(
      File file, String imageName, int quality) async {
    var tmpDir = await getTemporaryDirectory();
    var tmpPath = tmpDir.path + imageName;
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      tmpPath,
      quality: quality,
    );

    print(file.lengthSync());
    print(result!.lengthSync());

    return result;
  }
}