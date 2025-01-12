import 'package:bikers/authentication/user.dart';
import 'package:bikers/home/home.dart';
import 'package:bikers/shared/widget/likeIcon.dart';
import 'package:bikers/shared/widget/loading.dart';
import 'package:bikers/shared/widget/speedDial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/api/thirdpage/tourApi.dart';

class ThirdApp extends StatefulWidget {
  @override
  _ThirdAppState createState() => _ThirdAppState();
}

class _ThirdAppState extends State<ThirdApp>
    with AutomaticKeepAliveClientMixin {
  final PagingController _pagingController = PagingController(firstPageKey: 0);
  Tour? _lastDocument;
  int _pageSize = 8;
  dynamic user;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<Users?>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _refreshList() async {
    await Future.delayed(Duration(microseconds: 500));
    _lastDocument = null;
    _pagingController.refresh();
  }

  _getProducts() async {
    if (_lastDocument == null) {
      TourList tourList = await Tour.getTourLatest(user.uid, _pageSize);
      int listLength = tourList.tourList.length;
      _lastDocument = tourList.tourList[listLength - 1];
      return tourList;
    } else {
      TourList tourList = await Tour.getTourLatestBeforeId(
          _lastDocument!.tourId, user.uid, _pageSize);
      int listLength = tourList.tourList.length;
      _lastDocument = tourList.tourList[listLength - 1];
      return tourList;
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      TourList? newItems = await _getProducts();
      if (newItems != null) {
        final isLastPage = newItems.tourList.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems.tourList);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems.tourList, nextPageKey);
        }
      }
    } catch (error) {
      print(error);
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          title: TextButton(
              onPressed: () {
                Get.offAll(() => Home());
              },
              child: Text('BIKERS',
                  style: GoogleFonts.permanentMarker(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white))),
          centerTitle: false,
          backgroundColor: Colors.black,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.toc),
              onPressed: () {},
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshList,
          child: PagedListView.separated(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Tour>(
                itemBuilder: (BuildContext context, dynamic item, int index) {
                  print(index);
                  return TourContent(item: item);
                },
                firstPageProgressIndicatorBuilder: (_) => Loading()),
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 0,
              );
            },
          ),
        ),
        floatingActionButton: MakeSpeedDial(
          heroTag: "third",
        ));
  }
}

class TourContent extends StatelessWidget {
  const TourContent({Key? key, required this.item}) : super(key: key);
  final Tour item;

  Widget columnContent(IconData icon, String text, String content) {
    return Row(children: [
      Icon(icon, size: 17, color: Colors.white),
      Text(text, style: GoogleFonts.abel(fontSize: 13, color: Colors.white)),
      Text(" " + content,
          style: GoogleFonts.abel(fontSize: 13, color: Colors.white)),
    ]);
  }

  Future likeFunc(String userId, Tour item) async {
    Map<String, String> body = {
      "user_id": userId,
      "tour_id": item.tourId.toString()
    };
    await Tour.likeTour(body);
  }

  Future unlikeFunc(userId, item) async {
    Map<String, String> body = {
      "user_id": userId,
      "tour_id": item.tourId.toString()
    };
    await Tour.unlikeTour(body);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    return Container(
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.grey[800],
        ),
        //constraints: BoxConstraints.tightForFinite(height: 120),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/profileImage.jpg'),
                radius: 25,
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    columnContent(Icons.calendar_today, " 날짜 : ",
                        DateFormat('MM/dd hh:mm').format(item.startDate)),
                    columnContent(Icons.attach_money, " 가격 : ", "10,000원"),
                    columnContent(Icons.account_box_outlined, " 인원 : ",
                        item.memberNum.toString() + "명"),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Expanded(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       Text("1/" + item.memberNum.toString(),
                    //           style: TextStyle(color: Colors.white)),
                    //       LikeIcon(
                    //           user: user,
                    //           item: item,
                    //           likeFunc: likeFunc,
                    //           unlikeFunc: unlikeFunc),
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {},
                          child: Text("참가하기",
                              style: GoogleFonts.abel(
                                  fontSize: 13, color: Colors.white))),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
