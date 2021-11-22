import 'package:flutter/material.dart';
import '/provider/imageEditProvider.dart';
import 'package:provider/provider.dart';

class ImageScrollView extends StatefulWidget {
  const ImageScrollView({Key? key}) : super(key: key);

  @override
  _ImageScrollViewState createState() => _ImageScrollViewState();
}

class _ImageScrollViewState extends State<ImageScrollView> {
  late CurrentIndexNotifier currentIndex;
  var imageFileList;

  @override
  Widget build(BuildContext context) {
    print("ImageScrollView Build!");
    currentIndex = context.watch<CurrentIndexNotifier>();
    imageFileList =
        context.select((ImageInfoNotifier item) => item.imageFileList);
    return Container(
        color: const Color(0xFF424242),
        height: 80,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageFileList.length,
            itemBuilder: (context, index) {
              return currentIndex.currentIndex != index
                  ? InkWell(
                      onTap: () {
                        currentIndex.changeCurrentIndex(index);
                        context.read<GestureNotifier>().changeGesture(false);
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        child: Card(
                            clipBehavior: Clip.hardEdge,
                            // ignore: unnecessary_null_comparison
                            child: Image(
                              image: FileImage(imageFileList[index]),
                              fit: BoxFit.cover,
                            )),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        currentIndex.changeCurrentIndex(index);
                        context.read<GestureNotifier>().changeGesture(false);
                      },
                      child: Stack(children: [
                        Container(
                          width: 80,
                          height: 80,
                          child: Card(
                              clipBehavior: Clip.hardEdge,
                              // ignore: unnecessary_null_comparison
                              child: Image(
                                image: FileImage(imageFileList[index]),
                                fit: BoxFit.cover,
                              )),
                        ),
                        const Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xFF82B1FF),
                              size: 24.0,
                            ))
                      ]),
                    );
            }));
  }
}