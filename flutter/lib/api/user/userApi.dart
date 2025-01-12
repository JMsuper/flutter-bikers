import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';
import '../apiConfig.dart';

class UserApi {
  final String id;
  final String mobileNumber;
  final String nickName;
  final String name;
  final int roleId;
  final DateTime birth;
  final String sex;
  String? imageUrl;

  UserApi(
      {required this.id,
      required this.mobileNumber,
      required this.nickName,
      required this.name,
      required this.roleId,
      required this.birth,
      required this.sex,
      this.imageUrl});

  static Map userToMap({
    required id,
    required mobileNumber,
    required nickName,
    required name,
    required birth,
    required sex,
  }) {
    Map<String, String> map = {
      "id": id,
      "mobile_number": mobileNumber,
      "nick_name": nickName,
      "name": name,
      "birth": birth,
      "sex": sex
    };
    return map;
  }

  factory UserApi.fromJson(Map<String, dynamic> json) {
    return UserApi(
        id: json["id"],
        mobileNumber: json["mobile_number"],
        nickName: json["nick_name"],
        name: json["name"],
        roleId: json["role_id"],
        birth: DateTime.parse(json["birth"]),
        sex: json["sex"],
        imageUrl: json["imageUrl"]);
  }

  static Future getUserInfo(String uid) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "user/info" + "?id=$uid");
    final response = await http.get(url);
    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Failed to post feed content');
    }
    return response.body;
  }

  static Future isNotExistedNickName(String nickName) async {
    Uri url =
        Uri.parse(ApiConfig.apiUrl + "user/nickName" + "?nickName=$nickName");
    final response = await http.get(url);
    if (response.statusCode != 200) {
      print(json.decode(response.body)["nickName"]);
      throw Exception('Failed to get isExistedNickName');
    }
    Map jsonData = json.decode(response.body);
    print(jsonData["isNotExist"]);
    return jsonData["isNotExist"];
  }

  static Future getFollower(String fromUser) async {
    Uri url =
        Uri.parse(ApiConfig.apiUrl + "user/follower" + "?from_user=$fromUser");
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to get Follewer');
    }
    Map jsonData = json.decode(response.body);
    return jsonData["isNotExist"];
  }

  static Future getFollowCount(String userId) async {
    Uri url =
        Uri.parse(ApiConfig.apiUrl + "user/followCount" + "?user_id=$userId");
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to get FolleweCount');
    }
    Map jsonData = json.decode(response.body);
    return jsonData;
  }

  static Future save(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "user/new");
    final response = await http.post(url, body: body);

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Failed to post User');
    }
  }

  static Future postFollower(
      {required String toUser, required String fromUser}) async {
    Map<String, String> body = {"to_user": toUser, "from_user": fromUser};
    Uri url = Uri.parse(ApiConfig.apiUrl + "user/follower");
    final response = await http.post(url, body: body);
    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Failed to post follower');
    }

    Map jsonData = json.decode(response.body);
    if (jsonData.containsKey("isExist")) {
      return false;
    } else {
      return true;
    }
  }

  static Future deleteFollower(
      {required String toUser, required String fromUser}) async {
    Map<String, String> body = {"to_user": toUser, "from_user": fromUser};
    Uri url = Uri.parse(ApiConfig.apiUrl + "user/follower");
    final response = await http.delete(url, body: body);

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Failed to delete follower');
    }
  }
}
