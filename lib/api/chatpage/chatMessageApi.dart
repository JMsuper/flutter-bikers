import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../apiConfig.dart';

class ChatMessageList {
  List<ChatMessage> chatMessegeList = [];
  ChatMessageList(this.chatMessegeList);

  factory ChatMessageList.fromJson(List<dynamic> list) {
    List<ChatMessage> newList = list.map((e) => ChatMessage.fromJson(e)).toList();
    return ChatMessageList(newList);
  }
}

class ChatMessage {
  final int roomId;
  final String writerId;
  final String contents;
  int isviewed;
  final DateTime createdDate;

  ChatMessage(
      {required this.roomId,
      required this.writerId,
      required this.contents,
      required this.isviewed,
      required this.createdDate});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      roomId: json["room_id"],
      writerId: json["writer_id"],
      contents: json["contents"],
      isviewed: json["isviewed"],
      createdDate: DateTime.parse(json["created_date"]));
  }

  static Future<ChatMessageList> getChatMessage(int roomId, String userId) async {
    Uri url = Uri.parse(
        ApiConfig.apiUrl + "chat/room/message?room_id=$roomId&user_id=$userId");
    final response = await http.get(url);
    List<dynamic> list = json.decode(response.body);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return ChatMessageList.fromJson(list);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to get ChatMessage');
    }
  }

  static Future<ChatMessageList> getChatInShop(int goodsId, String userId) async {
    Uri url = Uri.parse(
        ApiConfig.apiUrl + "chat/inShop?goods_id=$goodsId&user_id=$userId");
    final response = await http.get(url);
    List<dynamic> list = json.decode(response.body);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return ChatMessageList.fromJson(list);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to get ChatInShop');
    }
  }

  static Future<void> postChatMessage(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "chat/room/message");
    final response = await http.post(url, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to post chatMessage');
    }
  }
}
