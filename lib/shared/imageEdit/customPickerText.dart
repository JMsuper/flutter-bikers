import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class KoreanTextDelegate extends AssetsPickerTextDelegate {
  @override
  String confirm = '선택';

  @override
  String cancel = '취소';

  @override
  String edit = '편집';

  @override
  String gifIndicator = 'GIF';

  @override
  String heicNotSupported = 'Unsupported HEIC asset type.';

  @override
  String loadFailed = 'Load failed';

  @override
  String original = '원본';

  @override
  String preview = '미리보기';

  @override
  String select = '선택';

  @override
  String unSupportedAssetType = 'Unsupported HEIC asset type.';
}

class KoreanCameraPickerTextDelegate implements CameraPickerTextDelegate {
  factory KoreanCameraPickerTextDelegate() => _instance;

  KoreanCameraPickerTextDelegate._internal();

  static final KoreanCameraPickerTextDelegate _instance =
      KoreanCameraPickerTextDelegate._internal();

  @override
  String confirm = '완료';

  @override
  String shootingTips = '';

  @override
  String loadFailed = '';
}

class CustomSortPathDelegate extends CommonSortPathDelegate {
  const CustomSortPathDelegate();
  @override
  void sort(List<AssetPathEntity> list) {
    for (final AssetPathEntity entity in list) {
      if (entity.isAll) {
        entity.name = '전체사진';
      }
    }
  }
}