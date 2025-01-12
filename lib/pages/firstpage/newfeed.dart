import 'dart:convert';

import 'package:bikers/api/firstpage/feedApi.dart';
import 'package:bikers/authentication/user.dart';
import 'package:bikers/shared/widget/makeTextField.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:bikers/shared/widget/loading.dart';
import 'package:provider/provider.dart';
import '/provider/imageEditProvider.dart';
import '/shared/imageEdit/editImageCameraPage.dart';
import '/shared/imageEdit/editImageGalleryPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class NewFeed extends StatefulWidget {
  @override
  _NewFeedState createState() => _NewFeedState();
}

class _NewFeedState extends State<NewFeed> {
  List<File> mainImageList = [];
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final _storage = FirebaseStorage.instance;
  final listLenghth = 10;
  final contentController = TextEditingController();
  dynamic user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<Users?>(context);
  }

  Future uploadFeed() async {
    List<Map<String, dynamic>> imageUrlList = [];
    for (int i = 0; i < mainImageList.length; i++) {
      String imageName = mainImageList[i].path.split('/').last;
      var snapshot = await _storage
          .ref()
          .child('feed_images/${DateTime.now()}$imageName')
          .putFile(mainImageList[i]);
      imageUrlList.add(
          {"image_url": await snapshot.ref.getDownloadURL(), "sequence": i});
    }
    if (imageUrlList.length == 0) {
      Feed.postTextFeed(Feed.feedTextToMap(
          writerId: user.uid,
          contents: contentController.text,
          hasImage: "0"));
    } else {
      Feed.postImageFeed(Feed.feedImageToMap(
          writerId: user.uid,
          contents: contentController.text,
          hasImage: "1",
          imageUrls: json.encode(imageUrlList)));
    }
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13 이상에서는 photos, videos 권한 사용
        final photos = await Permission.photos.status;
        final videos = await Permission.videos.status;
        
        if (!photos.isGranted || !videos.isGranted) {
          final results = await [
            Permission.photos,
            Permission.videos,
          ].request();
          return results[Permission.photos]!.isGranted && 
                 results[Permission.videos]!.isGranted;
        }
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
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
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              uploadFeed();
                              loading = true;
                              Navigator.pop(context);
                            });
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
                                            duration:
                                                const Duration(seconds: 2),
                                            content: const Text(
                                                '선택 가능한 사진 개수를 초과했습니다.'),
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
                                                                Icons
                                                                    .camera_alt,
                                                                color: Colors
                                                                    .white,
                                                                size: 26,
                                                              ),
                                                              SizedBox(
                                                                width: 7,
                                                              ),
                                                              Text(
                                                                '직접촬영',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ]),
                                                        onTap: () async {
                                                          File? imageMap = await Navigator
                                                                  .of(context)
                                                              .push(MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          EditImageCamaraPage()));
                                                          if (imageMap !=
                                                              null) {
                                                            setState(() {
                                                              mainImageList.add(
                                                                  imageMap);
                                                            });
                                                          }
                                                          Navigator.of(context)
                                                              .pop();
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
                                                                color: Colors
                                                                    .white,
                                                                size: 28,
                                                              ),
                                                              SizedBox(
                                                                width: 7,
                                                              ),
                                                              Text(
                                                                '폴더선택',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ]),
                                                        onTap: () async {
                                                          bool permitted =
                                                              await checkPermission();
                                                          if (permitted) {
                                                            List<
                                                                File>? imageList = await Navigator
                                                                    .of(context)
                                                                .push(MaterialPageRoute(
                                                                    builder: (context) => MultiProvider(
                                                                            providers: [
                                                                              ChangeNotifierProvider<ImageInfoNotifier>(create: (_) => ImageInfoNotifier()),
                                                                              ChangeNotifierProvider<GestureNotifier>(create: (_) => GestureNotifier()),
                                                                              ChangeNotifierProvider<CurrentIndexNotifier>(create: (_) => CurrentIndexNotifier()),
                                                                              ChangeNotifierProvider<AspectRatiosNotifier>(create: (_) => AspectRatiosNotifier()),
                                                                              ChangeNotifierProvider<DefaultListNotifier>(create: (_) => DefaultListNotifier()),
                                                                            ],
                                                                            child: EditImagePage(
                                                                              maxAssets: 10 - mainImageList.length,
                                                                            ))));
                                                            if (imageList !=
                                                                null) {
                                                              setState(() {
                                                                imageList.forEach(
                                                                    (element) {
                                                                  mainImageList
                                                                      .add(
                                                                          element);
                                                                });
                                                              });
                                                            }
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: const Text(
                                                                  '권한 허용이 필요합니다.'),
                                                              action:
                                                                  SnackBarAction(
                                                                      label:
                                                                          "앱 설정",
                                                                      onPressed:
                                                                          () {
                                                                        openAppSettings();
                                                                      }),
                                                            ));
                                                          }

                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      child: ListTile(
                                                        dense: true,
                                                        title: Text(
                                                          '취소',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
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
                      MakeTextField(
                        controller: contentController,
                        text: "내용",
                        maxLines: 20,
                        maxLength: 400,
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
