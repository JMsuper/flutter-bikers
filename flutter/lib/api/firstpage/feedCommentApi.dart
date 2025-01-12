import 'package:http/http.dart' as http;
import 'dart:async';
import '../apiConfig.dart';

class FeedComment {
  final int id;
  final String writerId;
  final int feedId;
  final String contents;
  int likeCount;
  int commentCount;
  final DateTime createdDate;
  final String nickName;
  final String? imageUrl;
  int isliked;

  FeedComment(
      {required this.id,
      required this.writerId,
      required this.feedId,
      required this.contents,
      required this.likeCount,
      required this.commentCount,
      required this.createdDate,
      required this.nickName,
      required this.imageUrl,
      required this.isliked});

  factory FeedComment.fromJson(Map<String, dynamic> json) {
    return FeedComment(
        id: json["id"],
        writerId: json["writer_id"],
        feedId: json["feed_id"],
        contents: json["contents"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        createdDate: DateTime.parse(json["created_date"]),
        nickName: json["nick_name"],
        imageUrl: json["image_url"],
        isliked: json["isliked"]);
  }

  static Future getFeedComment(int feedId,String userId) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feedComment/?feed_id=$feedId&user_id=$userId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return response.body;
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  static Future postComment(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feedComment/");
    final response = await http.post(url, body: body);

    if (response.statusCode == 201) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return response.body;
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  static Future<void> like(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feedComment/liked");
    final response = await http.put(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to like feed comment');
    }
  }

  static Future<void> unlike(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feedComment/unliked");
    final response = await http.put(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to unlike feed comment');
    }
  }
}
