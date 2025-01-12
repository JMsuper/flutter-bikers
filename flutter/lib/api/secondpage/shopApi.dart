import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../apiConfig.dart';

class ShopList {
  List<Shop> shopList = [];
  ShopList(this.shopList);

  factory ShopList.fromJson(List<dynamic> list) {
    List<Shop> newList = list.map((e) => Shop.fromJson(e)).toList();
    return ShopList(newList);
  }
}

class Shop {
  final int goodsId;
  final String writerId;
  final String title;
  final String contents;
  final int price;
  final DateTime createdDate;
  int viewCount;
  int likeCount;
  final int categoryId;
  final int regionId;
  final int goodsStateId;
  int isliked;
  List<dynamic> imageUrlList = [];

  Shop(
      {required this.goodsId,
      required this.writerId,
      required this.title,
      required this.contents,
      required this.price,
      required this.createdDate,
      required this.viewCount,
      required this.likeCount,
      required this.categoryId,
      required this.regionId,
      required this.goodsStateId,
      required this.isliked,
      required this.imageUrlList});

// {
//     "writer_id":"6BjxQNOow4RXub7ChmbbPMNU8qA3",
//     "title":"테스트 샵 페이지 입니다.",
//     "contents":"테스트 샵 페이지 입니다.",
//     "price":300000,
//     "category_id":1,
//     "region_id":1,
//         "imageUrls" : [
//         {
//             "image_url": "url1",
//             "sequence":0
//         },
//         {
//             "image_url": "url2",
//             "sequence":1
//         }
//     ]
// }

  static Map<String, dynamic> shopToMap(
      {required writerId,
      required title,
      required contents,
      required price,
      required categoryId,
      required regionId,
      required List<Map<String,dynamic>> imageUrls}) {
    Map<String, dynamic> feedToMap = {};
    feedToMap["writer_id"] = writerId;
    feedToMap["title"] = title;
    feedToMap["contents"] = contents;
    feedToMap["price"] = price;
    feedToMap["category_id"] = categoryId;
    feedToMap["region_id"] = regionId;
    feedToMap["imageUrls"] = json.encode(imageUrls);
    return feedToMap;
  }

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
        goodsId: json["goods_id"],
        writerId: json["writer_id"],
        title: json["title"],
        contents: json["contents"],
        price: json["price"],
        createdDate: DateTime.parse(json["created_date"]),
        viewCount: json["view_count"],
        likeCount: json["like_count"],
        categoryId: json["category_id"],
        regionId: json["region_id"],
        goodsStateId: json["goods_state_id"],
        isliked: json["isliked"],
        imageUrlList: json["imageUrlList"]);
  }

  static Future<ShopList> getShopLatest(String userId, int limit) async {
    Uri url = Uri.parse(
        ApiConfig.apiUrl + "shop/latest?user_id=$userId&limit=$limit");
    final response = await http.get(url);
    List<dynamic> list = json.decode(response.body);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return ShopList.fromJson(list);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to get ShopFeed');
    }
  }

  static Future<ShopList> getShopLatestBeforeId(
      int goodsId, String userId, int limit) async {
    Uri url = Uri.parse(ApiConfig.apiUrl +
        "shop/latest?goods_id=$goodsId&user_id=$userId&limit=$limit");
    final response = await http.get(url);
    List<dynamic> list = json.decode(response.body);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return ShopList.fromJson(list);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to get ShopFeed');
    }
  }

  static Future<void> postShopFeed(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "shop/");
    final response = await http.post(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to post shopFeed content');
    }
  }

  // static Future<void> deleteShopFeed(Object body) async {
  //   Uri url = Uri.parse(ApiConfig.apiUrl + "feed/");
  //   final response = await http.delete(url, body: body);

  //   if (response.statusCode != 201) {
  //     print(response.body);
  //     throw Exception('Failed to delete feed content');
  //   }
  // }

  static Future<void> likeShopFeed(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "shop/liked");
    final response = await http.put(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to like shop content');
    }
  }

  static Future<void> unlikeShopFeed(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "shop/unliked");
    final response = await http.put(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to unlike shop content');
    }
  }
}
