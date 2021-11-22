import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../apiConfig.dart';

class TourList {
  List<Tour> tourList = [];
  TourList(this.tourList);

  factory TourList.fromJson(List<dynamic> list) {
    List<Tour> newList = list.map((e) => Tour.fromJson(e)).toList();
    return TourList(newList);
  }
}

class Tour {
  final int tourId;
  final String writerId;
  final String title;
  final String contents;
  final double regionLat;
  final double regionLng;
  final DateTime startDate;
  final int memberNum;
  int likeCount;
  final DateTime createdDate;
  final int viewCount;
  int isliked;

  Tour(
      {required this.tourId,
      required this.writerId,
      required this.title,
      required this.contents,
      required this.regionLat,
      required this.regionLng,
      required this.startDate,
      required this.memberNum,
      required this.likeCount,
      required this.createdDate,
      required this.viewCount,
      required this.isliked});

  static Map<String, String> tourDataToMap(
      {required writerId,
      required title,
      required contents,
      required regionLat,
      required regionLng,
      required startDate,
      required memberNum}) {
    Map<String, String> tourToMap = {};
    tourToMap["writer_id"] = writerId;
    tourToMap["title"] = title;
    tourToMap["contents"] = contents;
    tourToMap["region_lat"] = regionLat;
    tourToMap["region_lng"] = regionLng;
    tourToMap["start_date"] = startDate;
    tourToMap["member_num"] = memberNum;
    return tourToMap;
  }

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
        tourId: json["tour_id"],
        writerId: json["writer_id"],
        title: json["title"],
        contents: json["contents"],
        regionLat: json["region_lat"].toDouble(),
        regionLng: json["region_lng"].toDouble(),
        startDate: DateTime.parse(json["start_date"]),
        memberNum: json["member_num"],
        likeCount: json["like_count"],
        createdDate: DateTime.parse(json["created_date"]),
        viewCount: json["view_count"],
        isliked: json["isliked"]);
  }

  static Future<TourList> getTourLatest(String userId, int limit) async {
    Uri url = Uri.parse(
        ApiConfig.apiUrl + "tour/latest?user_id=$userId&limit=$limit");
    final response = await http.get(url);
    print(response.body);
    List<dynamic> list = json.decode(response.body);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return TourList.fromJson(list);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  static Future<TourList> getTourLatestBeforeId(
      int tourId, String userId, int limit) async {
    Uri url = Uri.parse(ApiConfig.apiUrl +
        "tour/latest?tour_id=$tourId&user_id=$userId&limit=$limit");
    final response = await http.get(url);
    List<dynamic> list = json.decode(response.body);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return TourList.fromJson(list);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  static Future<TourList> getTourAll() async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "tour/all");
    final response = await http.get(url);
    List<dynamic> list = json.decode(response.body);

    if (response.statusCode == 200) {
      // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
      return TourList.fromJson(list);
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception('Failed to load post');
    }
  }

  static Future<void> postTour(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "tour/");
    final response = await http.post(url, body: body);

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Failed to post tour content');
    }
  }

  static Future<void> deleteTour(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "tour/");
    final response = await http.delete(url, body: body);

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Failed to delete tour content');
    }
  }

  static Future<void> likeTour(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "tour/liked");
    final response = await http.put(url, body: body);

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Failed to like tour content');
    }
  }

  static Future<void> unlikeTour(Object body) async {
    Uri url = Uri.parse(ApiConfig.apiUrl + "tour/unliked");
    final response = await http.put(url, body: body);

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Failed to unlike tour content');
    }
  }
}
