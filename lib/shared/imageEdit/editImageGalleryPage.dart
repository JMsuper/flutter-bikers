import 'package:flutter/material.dart';
import 'editImagePageElement.dart';
import '/provider/imageEditProvider.dart';
import 'package:provider/provider.dart';
import 'widgets/editScreen.dart';
import 'widgets/imageScrollView.dart';
import 'widgets/customBottomBar.dart';
import 'dart:io';

class EditImagePage extends StatefulWidget {
  const EditImagePage({this.maxAssets});
  final maxAssets;

  @override
  EditImagePageState createState() => EditImagePageState();
}

class EditImagePageState extends State<EditImagePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      pickGallery(context, null, widget.maxAssets);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("EditImagePage Build");
    var imageFileNotifier =
        context.select((ImageInfoNotifier item) => item.imageFileList);
    var imageEditorKeyNotifier =
        context.select((ImageInfoNotifier item) => item.imageEditorKeyList);
    var gestureNotifier = context.watch<GestureNotifier>();
    var currentIndexNotifier = context.watch<CurrentIndexNotifier>();
    var aspectRatiosNotifier = context.read<AspectRatiosNotifier>();
    return SafeArea(
        child: context.select((ImageInfoNotifier item) => item.isListNotEmpty)
            ? Scaffold(
                body: Column(children: [
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: (imageEditorKeyNotifier[
                                          currentIndexNotifier.currentIndex]
                                      .currentState !=
                                  null &&
                              gestureNotifier.gestured)
                          ? AppBar(
                              key: const Key("edited"),
                              backgroundColor: Colors.grey,
                              toolbarHeight: 45,
                              leading: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                  onPressed: () {
                                    context.read<ImageInfoNotifier>().reset(
                                        currentIndexNotifier.currentIndex);
                                    aspectRatiosNotifier.changeAspectRatio(
                                        aspectRatiosNotifier
                                            .aspectRatios.first);
                                    gestureNotifier.changeGesture(false);
                                  }),
                              centerTitle: true,
                              actions: [
                                  TextButton(
                                    onPressed: () async {
                                      File file = await saveCroppedImage(
                                          state: imageEditorKeyNotifier[
                                                  currentIndexNotifier
                                                      .currentIndex]
                                              .currentState!) as File;
                                      context
                                          .read<ImageInfoNotifier>()
                                          .updateImageInfo(
                                              currentIndexNotifier.currentIndex,
                                              file);
                                      gestureNotifier.changeGesture(false);
                                    },
                                    child: Text(
                                      "저장",
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 16),
                                    ),
                                  )
                                ])
                          : AppBar(
                              key: Key("notEdited"),
                              leading: IconButton(
                                  icon: const Icon(
                                    Icons.keyboard_backspace,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  onPressed: () async {
                                    var defaultList =
                                        context.read<DefaultListNotifier>();
                                    context
                                        .read<ImageInfoNotifier>()
                                        .imageInfoNotifierReset();
                                    gestureNotifier.changeGesture(false);
                                    await pickGallery(
                                        context,
                                        defaultList.defaultList,
                                        widget.maxAssets);
                                  }),
                              centerTitle: true,
                              elevation: 10,
                              toolbarHeight: 45,
                              backgroundColor: const Color(0xFF212121),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(imageFileNotifier);
                                      context
                                          .read<ImageInfoNotifier>()
                                          .imageInfoNotifierReset();
                                      gestureNotifier.gestureNotifierReset();
                                      currentIndexNotifier
                                          .currentIndexNotifierReset();
                                      aspectRatiosNotifier
                                          .aspectRatiosNotifierReset();
                                      context
                                          .read<DefaultListNotifier>()
                                          .defaultListNotifierReset();
                                    },
                                    child: const Text(
                                      "완료",
                                      style:
                                          TextStyle(color: Color(0xFFFFFFFF)),
                                    ))
                              ],
                            )),
                  ImageScrollView(),
                  EditScreen(),
                  Container(height: 1, color: const Color(0xFF9E9E9E))
                ]),
                bottomNavigationBar: CustomBottomBar())
            : Center(child: const CircularProgressIndicator()));
  }
}