import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../apiConfig.dart';

class FeedList {
  List<Feed> feedList = [];
  FeedList(this.feedList);

  factory FeedList.fromJson(List<dynamic> list) {
    List<Feed> newList = list.map((e) => Feed.fromJson(e)).toList();
    return FeedList(newList);
  }
}

class Feed {
  final int id;
  final String writerId;
  final String contents;
  int likeCount;
  int commentCount;
  final DateTime createdDate;
  final int hasImage;
  // imageUrlList는 게시물에 담긴 image들이다.
  List<dynamic>? imageUrlList = [];
  int isliked;
  final String writerNickName;
  // imageUrl은 프로필 이미지 url이다.
  final String? imageUrl;
  int? isfollower;

  Feed(
      {required this.id,
      required this.writerId,
      required this.contents,
      required this.likeCount,
      required this.commentCount,
      required this.createdDate,
      required this.hasImage,
      this.imageUrlList,
      required this.isliked,
      required this.writerNickName,
      required this.imageUrl,
      required this.isfollower});

  static Map<String, String> feedTextToMap({
    required writerId,
    required contents,
    required hasImage,
  }) {
    Map<String, String> tourToMap = {};
    tourToMap["writer_id"] = writerId;
    tourToMap["contents"] = contents;
    tourToMap["has_image"] = hasImage;
    return tourToMap;
  }

  static Map<String, dynamic> feedImageToMap(
      {required writerId,
      required contents,
      required hasImage,
      required imageUrls}) {
    Map<String, dynamic> tourToMap = {};
    tourToMap["writer_id"] = writerId;
    tourToMap["contents"] = contents;
    tourToMap["has_image"] = hasImage;
    tourToMap["imageUrls"] = imageUrls;
    return tourToMap;
  }

  factory Feed.fromJson(Map<String, dynamic> json) {
    if (json["has_image"] == 1) {
      return Feed(
          id: json["id"],
          writerId: json["writer_id"],
          contents: json["contents"],
          likeCount: json["like_count"],
          commentCount: json["comment_count"],
          createdDate: DateTime.parse(json["created_date"]),
          imageUrlList: json["imageUrlList"],
          hasImage: json["has_image"],
          isliked: json["isliked"],
          writerNickName: json["nick_name"],
          imageUrl: json["image_url"],
          isfollower:
              json.containsKey("isfollower") ? json["isfollower"] : null);
    } else {
      return Feed(
          id: json["id"],
          writerId: json["writer_id"],
          contents: json["contents"],
          likeCount: json["like_count"],
          commentCount: json["comment_count"],
          createdDate: DateTime.parse(json["created_date"]),
          hasImage: json["has_image"],
          isliked: json["isliked"],
          writerNickName: json["nick_name"],
          imageUrl: json["image_url"],
          isfollower:
              json.containsKey("isfollower") ? json["isfollower"] : null);
    }
  }

  static Future<FeedList> getFeedLatest(String userId, int limit) async {
    Uri url = Uri.parse(
        ApiConfig.apiUrl + "feed/latest?user_id=$userId&limit=$limit");
    final response = await http.get(url);
    List<dynamic> list = json.decode(response.body);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return FeedList.fromJson(list);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  static Future<FeedList> getFeedLatestBeforeId(
      int feedId, String userId, int limit) async {
    Uri url = Uri.parse(ApiConfig.apiUrl +
        "feed/latest?feed_id=$feedId&user_id=$userId&limit=$limit");
    final response = await http.get(url);
    List<dynamic> list = json.decode(response.body);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return FeedList.fromJson(list);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  static Future<FeedList> getFollowerFeed(String userId, int limit) async {
    Uri url = Uri.parse(
        ApiConfig.apiUrl + "feed/follower?user_id=$userId&limit=$limit");
    final response = await http.get(url);
    List<dynamic> list = json.decode(response.body);
    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return FeedList.fromJson(list);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to get followerFeed');
    }
  }

  static Future<FeedList> getFollowerFeedBeforeId(
      int feedId, String userId, int limit) async {
    Uri url = Uri.parse(ApiConfig.apiUrl +
        "feed/follower?feed_id=$feedId&user_id=$userId&limit=$limit");
    final response = await http.get(url);
    List<dynamic> list = json.decode(response.body);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return FeedList.fromJson(list);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to get followerFeed');
    }
  }

  static Future getFeedCount(String userId) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feed/count" + "?user_id=$userId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      Map jsonData = json.decode(response.body);
      return jsonData["feed_count"];
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  static Future<void> postTextFeed(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feed/text");
    final response = await http.post(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to post feed content');
    }
  }

  static Future<void> postImageFeed(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feed/image");
    final response = await http.post(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to post feed content');
    }
  }

  static Future<void> deleteFeed(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feed/");
    final response = await http.delete(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to delete feed content');
    }
  }

  static Future<void> likeFeed(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feed/liked");
    final response = await http.put(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to like feed content');
    }
  }

  static Future<void> unlikeFeed(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feed/unliked");
    final response = await http.put(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to unlike feed content');
    }
  }
}
