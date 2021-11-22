import 'package:http/http.dart' as http;
import 'dart:async';
import '../apiConfig.dart';

class FeedChildComment {
  final int id;
  final String writerId;
  final int feedCommentId;
  final String contents;
  int likeCount;
  final DateTime createdDate;
  final String nickName;
  final String? imageUrl;
  int isliked;

  FeedChildComment(
      {required this.id,
      required this.writerId,
      required this.feedCommentId,
      required this.contents,
      required this.likeCount,
      required this.createdDate,
      required this.nickName,
      required this.imageUrl,
      required this.isliked});

  factory FeedChildComment.fromJson(Map<String, dynamic> json) {
    return FeedChildComment(
        id: json["id"],
        writerId: json["writer_id"],
        feedCommentId: json["feed_comment_id"],
        contents: json["contents"],
        likeCount: json["like_count"],
        createdDate: DateTime.parse(json["created_date"]),
        nickName: json["nick_name"],
        imageUrl: json["image_url"],
        isliked: json["isliked"]);
  }

  static Future getFeedChildComment(int feedCommentId,String userId) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feedComment/child/?feed_comment_id=$feedCommentId&user_id=$userId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return response.body;
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  static Future postChildComment(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feedComment/child");
    final response = await http.post(url, body: body);

    if (response.statusCode == 201) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return response.body;
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  static Future<void> childLike(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feedComment/child/liked");
    final response = await http.put(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to like feed comment');
    }
  }

  static Future<void> childUnlike(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "feedComment/child/unliked");
    final response = await http.put(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to unlike feed comment');
    }
  }
}
