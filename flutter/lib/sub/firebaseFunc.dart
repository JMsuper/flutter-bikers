import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFunc extends ChangeNotifier {
  FirebaseFunc();

  static void createShopFeed(List<String> urls, String title, String category,
      String region, int price, String content) async {
    await FirebaseFirestore.instance.collection("shopFeedContents").doc().set({
      "imagesUrl": urls,
      "title": title,
      "category": category,
      "region": region,
      "price": price,
      "content": content,
      "date": FieldValue.serverTimestamp()
    });
  }

  static void deleteShopFee(String docID) async {
    await FirebaseFirestore.instance
        .collection("shopFeedContents")
        .doc(docID)
        .delete();
  }

  static void createShopTestFeed() async {
    for (int index = 0; index < 100; index++) {
      await FirebaseFirestore.instance
          .collection("shopFeedContents")
          .doc()
          .set({
        "imagesUrl": ["https://picsum.photos/200/300"],
        "title": index.toString(),
        "category": index.toString(),
        "region": index.toString(),
        "price": index,
        "content": index.toString(),
        "date": FieldValue.serverTimestamp()
      });
    }
  }

// 아직 사용자 계정과 연결되어 있지 않아 사용자의 프로필 사진 정보와 이름은 가져올 수 없다.
  static void createFeed(List<String> urls, String text) {
    FirebaseFirestore.instance.collection("feedContents").doc().set({
      "imagesUrl": urls,
      "text": text,
      "date": FieldValue.serverTimestamp()
    });
  }
}