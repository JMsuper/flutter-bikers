import 'package:get/get.dart';

class DateController extends GetxController {
  static DateController get to => Get.find();
  DateTime date = DateTime.now();
  bool isChanging = false;
  void updateDate(DateTime newDate) {
    date = newDate;
    update();
  }

  void changeColor() {
    isChanging = !isChanging;
    update();
  }
}

class TimeController extends GetxController {
  static TimeController get to => Get.find();
  DateTime time = DateTime.now();
  bool isChanging = false;
  void updateTime(DateTime newTime) {
    time = newTime;
    update();
  }

  void changeColor() {
    isChanging = !isChanging;
    update();
  }
}

class MemberController extends GetxController {
  static MemberController get to => Get.find();
  bool isChanging = false;
  int count = 5;
  void updateCount(int newCount) {
    count = newCount;
    update();
  }

  void changeColor() {
    isChanging = !isChanging;
    update();
  }
}

class LocationController extends GetxController {
  static LocationController get to => Get.find();
  String location = "현재 위치로 지정";
  String lat = "";
  String lng = "";
  void updateLocation(String newLocation, String lat, String lng) {
    location = newLocation;
    this.lat = lat;
    this.lng = lng;
    update();
  }
}
