import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class KoreanTextDelegate extends AssetPickerTextDelegate {
  const KoreanTextDelegate();

  @override
  String get confirm => '선택';

  @override
  String get cancel => '취소';

  @override
  String get edit => '편집';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get loadFailed => 'Load failed';

  @override
  String get original => '원본';

  @override
  String get preview => '미리보기';

  @override
  String get select => '선택';

  @override
  String get unSupportedAssetType => 'Unsupported HEIC asset type.';
}

class KoreanCameraPickerTextDelegate extends CameraPickerTextDelegate {
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

// class CustomSortPathDelegate extends CommonSortPathDelegate {
//   const CustomSortPathDelegate();
//   @override
//   void sort(List<PathWrapper<AssetPathEntity>> list) {
//     for (final PathWrapper<AssetPathEntity> wrapper in list) {
//       if (wrapper.path.isAll) {
//         wrapper.name = '전체사진';
//       }
//     }
//   }
// }