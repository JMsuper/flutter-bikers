import 'package:bikers/api/secondpage/shopApi.dart';
import 'package:bikers/authentication/user.dart';
import 'package:bikers/pages/secondpage/categorySelector.dart';
import 'package:bikers/pages/secondpage/regionAndCategory.dart';
import 'package:bikers/shared/permissionHandler.dart';
import 'package:bikers/shared/widget/makeTextField.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '/provider/imageEditProvider.dart';
import '/shared/imageEdit/editImageCameraPage.dart';
import '/shared/imageEdit/editImageGalleryPage.dart';

class NewFeedShopNoBike extends StatefulWidget {
  @override
  _NewFeedShopNoBikeState createState() => _NewFeedShopNoBikeState();
}

class _NewFeedShopNoBikeState extends State<NewFeedShopNoBike> {
  List<File> mainImageList = [];
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _storage = FirebaseStorage.instance;
  final listLenghth = 10;
  int selectedCategory = -1; // -1은 아직 선택되지 않은 것을 의미
  int selectedRegion = -1;
  dynamic user;

  Future uploadShopFeed() async {
    if (mainImageList.length > 0) {
      List<Map<String, dynamic>> imageUrlList = [];
      for (int i = 0; i < mainImageList.length; i++) {
        String imageName = mainImageList[i].path.split('/').last;
        var snapshot = await _storage
            .ref()
            .child('shop_images/${DateTime.now()}$imageName')
            .putFile(mainImageList[i]);
        imageUrlList.add(
            {"image_url": await snapshot.ref.getDownloadURL(), "sequence": i});
      }
      int categoryId = selectedCategory + 2;
      var body = Shop.shopToMap(
          writerId: user.uid,
          title: titleController.text,
          contents: contentController.text,
          price: priceController.text.replaceAll(RegExp(","), ""),
          categoryId: categoryId.toString(), // NoBike이기 때문에 2를 더해준다.
          regionId: selectedRegion.toString(),
          imageUrls: imageUrlList);

      await Shop.postShopFeed(body);
    }
  }

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<Users?>(context);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    priceController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('글 올리기',
            style: GoogleFonts.permanentMarker(
                fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          Center(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: TextButton(
                  child: Text('완료',
                      style: GoogleFonts.abel(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        mainImageList.length != 0 &&
                        selectedCategory != -1 &&
                        selectedRegion != -1) {
                      uploadShopFeed();
                      Navigator.pop(context);
                    } else if (mainImageList.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 1),
                        content: const Text('사진을 선택해주세요'),
                      ));
                      return;
                    } else if (selectedCategory == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 1),
                        content: const Text('카테고리를 선택해주세요'),
                      ));
                      return;
                    } else if (selectedRegion == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 1),
                        content: const Text('지역을 선택해주세요'),
                      ));
                      return;
                    }
                  }),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // +1 하는 이유는 앞에 사진 입력 아이콘이 계속 있게하려고
                    itemCount: mainImageList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Stack(children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Card(
                              child: IconButton(
                                splashRadius: 20,
                                iconSize: 30,
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  if (mainImageList.length == 10) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 2),
                                      content:
                                          const Text('선택 가능한 사진 개수를 초과했습니다.'),
                                    ));
                                  } else {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          color: Colors.black87,
                                          height: 150,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: ListTile(
                                                  dense: true,
                                                  title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.camera_alt,
                                                          color: Colors.white,
                                                          size: 26,
                                                        ),
                                                        SizedBox(
                                                          width: 7,
                                                        ),
                                                        Text(
                                                          '직접촬영',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ]),
                                                  onTap: () async {
                                                    File? imageMap = await Navigator
                                                            .of(context)
                                                        .push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditImageCamaraPage()));
                                                    if (imageMap != null) {
                                                      setState(() {
                                                        mainImageList
                                                            .add(imageMap);
                                                      });
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                              Container(
                                                child: ListTile(
                                                  dense: true,
                                                  title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.image,
                                                          color: Colors.white,
                                                          size: 28,
                                                        ),
                                                        SizedBox(
                                                          width: 7,
                                                        ),
                                                        Text(
                                                          '폴더선택',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ]),
                                                  onTap: () async {
                                                    bool permitted = Theme.of(
                                                                    context)
                                                                .platform ==
                                                            TargetPlatform
                                                                .android
                                                        ? await PermissionHandler
                                                            .checkAndroidPhotoPermission()
                                                        : await PermissionHandler
                                                            .checkIosPhotoPermission();
                                                    if (permitted) {
                                                      List<File>? imageList =
                                                          await Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      MultiProvider(
                                                                          providers: [
                                                                            ChangeNotifierProvider<ImageInfoNotifier>(create: (_) => ImageInfoNotifier()),
                                                                            ChangeNotifierProvider<GestureNotifier>(create: (_) => GestureNotifier()),
                                                                            ChangeNotifierProvider<CurrentIndexNotifier>(create: (_) => CurrentIndexNotifier()),
                                                                            ChangeNotifierProvider<AspectRatiosNotifier>(create: (_) => AspectRatiosNotifier()),
                                                                            ChangeNotifierProvider<DefaultListNotifier>(create: (_) => DefaultListNotifier()),
                                                                          ],
                                                                          child:
                                                                              EditImagePage(
                                                                            maxAssets:
                                                                                10 - mainImageList.length,
                                                                          ))));
                                                      if (imageList != null) {
                                                        setState(() {
                                                          imageList.forEach(
                                                              (element) {
                                                            mainImageList
                                                                .add(element);
                                                          });
                                                        });
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: const Text(
                                                            '권한 허용이 필요합니다.'),
                                                        action: SnackBarAction(
                                                            label: "앱 설정",
                                                            onPressed: () async{
                                                              await openAppSettings();
                                                            }),
                                                      ));
                                                    }

                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                              Container(
                                                child: ListTile(
                                                  dense: true,
                                                  title: Text(
                                                    '취소',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            style: BorderStyle.none,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          )),
                                      backgroundColor: Colors.white,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 12,
                            child: Text(
                              mainImageList.length.toString() +
                                  "/" +
                                  "$listLenghth",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            ),
                          ),
                        ]);
                      } else {
                        return InkWell(
                          onTap: () async {
                            setState(() {});
                          },
                          child: Stack(children: [
                            Container(
                              width: 100,
                              height: 100,
                              child: Card(
                                clipBehavior: Clip.hardEdge,
                                // ignore: unnecessary_null_comparison
                                child: mainImageList != null
                                    ? Image.file(mainImageList[index - 1],
                                        fit: BoxFit.cover)
                                    : Container(),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  mainImageList.removeAt(index - 1);
                                  setState(() {});
                                },
                                child: Opacity(
                                  opacity: 0.75,
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                            )
                          ]),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 40,
                  child: Row(
                    children: [
                      Icon(Icons.short_text, color: Colors.white),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            int returnNum =
                                await CategorySelctor.selectCategoryNoBike(
                                    context, selectedCategory);
                            selectedCategory = returnNum;
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('카테고리 설정',
                                  style: GoogleFonts.abel(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  selectedCategory == -1
                                      ? "미설정"
                                      : RegionNCategory
                                          .categoryListNoBike[selectedCategory],
                                  style: GoogleFonts.abel(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 40,
                  child: Row(
                    children: [
                      Icon(Icons.short_text, color: Colors.white),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            int returnNum = await CategorySelctor.selectRegion(
                                context, selectedRegion);
                            selectedRegion = returnNum;
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('지역 설정',
                                  style: GoogleFonts.abel(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  selectedRegion == -1
                                      ? "미설정"
                                      : RegionNCategory
                                          .regionList[selectedRegion],
                                  style: GoogleFonts.abel(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                MakeTextField(
                  controller: titleController,
                  text: "판매글 제목",
                  maxLines: 1,
                  maxLength: 20,
                  textInputType: TextInputType.multiline,
                  textInputFormatter: [],
                ),
                MakeTextField(
                  controller: priceController,
                  text: "가격(원)",
                  maxLines: 1,
                  maxLength: 13,
                  textInputType: TextInputType.number,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    ThousandsFormatter()
                  ],
                ),
                MakeTextField(
                  controller: contentController,
                  text: "내용",
                  maxLines: 10,
                  maxLength: 500,
                  textInputType: TextInputType.multiline,
                  textInputFormatter: [],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
