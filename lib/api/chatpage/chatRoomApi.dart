import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../apiConfig.dart';

class ChatRoomList {
  List<ChatRoom> chatRoomList = [];
  ChatRoomList(this.chatRoomList);

  factory ChatRoomList.fromJson(List<dynamic> list) {
    List<ChatRoom> newList = list.map((e) => ChatRoom.fromJson(e)).toList();
    return ChatRoomList(newList);
  }
}

class ChatRoom {
  final int roomId;
  final int goodsId;
  final String nickName;
  String contents;
  DateTime createdDate;
  String? imageUrl;
  int? notViewed;

  ChatRoom(
      {required this.goodsId,
      required this.roomId,
      required this.nickName,
      required this.contents,
      required this.imageUrl,
      required this.createdDate,
      required this.notViewed});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
        goodsId: json["goods_id"],
        roomId: json["room_id"],
        nickName: json["nick_name"],
        contents: json["contents"],
        imageUrl: json["image_url"],
        createdDate: DateTime.parse(json["created_date"]),
        notViewed: json["not_viewed"]);
  }

  static Future<ChatRoomList> getChatRoom(String userId) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "chat/room?user_id=$userId");
    final response = await http.get(url);
    List<dynamic> list = json.decode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return ChatRoomList.fromJson(list);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to get ShopFeed');
    }
  }

  static Future<String> createChatRoom(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "chat/room");
    final response = await http.post(url, body: body);
    if (response.statusCode != 200) {
      throw Exception('Failed to create chatRoom');
    }
    dynamic data = json.decode(response.body);
    return data["room_id"].toString();
  }
}
