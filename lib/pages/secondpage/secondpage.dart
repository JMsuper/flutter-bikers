import 'package:bikers/api/secondpage/shopApi.dart';
import 'package:bikers/authentication/user.dart';
import 'package:bikers/home/home.dart';
import 'package:bikers/pages/secondpage/detailShopFeed/detailShopFeed.dart';
import 'package:bikers/pages/secondpage/regionAndCategory.dart';
import 'package:bikers/pages/secondpage/settingpage_shop.dart';
import 'package:bikers/shared/widget/likeIcon.dart';
import 'package:bikers/shared/passedTime.dart';
import 'package:bikers/shared/widget/speedDial.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'searchpage_shop.dart';
import 'package:intl/intl.dart';
import '../../shared/widget/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SecondApp extends StatefulWidget {
  const SecondApp({Key? key}) : super(key: key);

  @override
  _SecondAppState createState() => _SecondAppState();
}

class _SecondAppState extends State<SecondApp>
//AutomaticKeepAliveClientMixin와 Ticker같이 쓰려면 어떻게 해야하는지 확인
    //with AutomaticKeepAliveClientMixin {
      with TickerProviderStateMixin{
  Shop? _lastDocument;
  final PagingController _pagingController = PagingController(firstPageKey: 0);
  int _pageSize = 12;
  late Size size;
  dynamic user;
  late AnimationController _anicontroller, _scaleController;
  RefreshController _refreshController = RefreshController();

  // 현재 시간을 알려주는 함수(DateTime 객체를 반환)
  late DateTime currentTime;

  Future _refreshList() async {
    _lastDocument = null;
    currentTime = DateTime.now();
    _pagingController.refresh();
    _refreshController.refreshCompleted();
  }

  _getProducts() async {
    if (_lastDocument == null) {
      ShopList shopList = await Shop.getShopLatest(user.uid, _pageSize);
      int listLength = shopList.shopList.length;
      _lastDocument = shopList.shopList[listLength - 1];
      return shopList;
    } else {
      ShopList shopList = await Shop.getShopLatestBeforeId(
          _lastDocument!.goodsId, user.uid, _pageSize);
      int listLength = shopList.shopList.length;
      _lastDocument = shopList.shopList[listLength - 1];
      return shopList;
    }
  }

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    _anicontroller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1));
    _scaleController =
        AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
    _refreshController.headerMode!.addListener(() {
      if (_refreshController.headerStatus == RefreshStatus.idle) {
        _scaleController.value = 0.0;
        _anicontroller.reset();
      } else if (_refreshController.headerStatus == RefreshStatus.refreshing) {
        _anicontroller.repeat();
      }
    });
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
    _refreshController.dispose();
    _scaleController.dispose();
    _anicontroller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<Users?>(context);
  }

  // @override
  // bool get wantKeepAlive => true;

  Future<void> _fetchPage(int pageKey) async {
    try {
      ShopList? newItems = await _getProducts();
      if (newItems != null) {
        final isLastPage = newItems.shopList.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems.shopList);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems.shopList, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
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
              onPressed: () {
                showSearch(context: context, delegate: Search(list));
              },
            ),
            IconButton(
              icon: Icon(Icons.tune),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingPageShop()));
              },
            ),
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _refreshList,
          child: PagedListView.separated(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Shop>(
                itemBuilder: (BuildContext context, dynamic item, int index) {
                  return Content(
                    item: item,
                    currentTime: currentTime,
                    user: user,
                  );
                },
                firstPageErrorIndicatorBuilder: (_) => Loading()),
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 5,
              );
            },
          ),
        ),
        floatingActionButton: MakeSpeedDial(
          heroTag: "second",
        ));
  }
}

class Content extends StatelessWidget {
  const Content(
      {Key? key,
      required this.item,
      required this.currentTime,
      required this.user})
      : super(key: key);
  final Shop item;
  final DateTime currentTime;
  final dynamic user;
  static var numFormat = NumberFormat("###,###,###,###원");

  Future likeFunc(String userId, Shop item) async {
    Map<String, String> body = {
      "user_id": userId,
      "goods_id": item.goodsId.toString()
    };
    await Shop.likeShopFeed(body);
  }

  Future unlikeFunc(String userId, Shop item) async {
    Map<String, String> body = {
      "user_id": userId,
      "goods_id": item.goodsId.toString()
    };
    await Shop.unlikeShopFeed(body);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 450),
            reverseTransitionDuration: Duration(milliseconds: 450),
            pageBuilder: (_, __, ___) => DetailShopFeed(
                  item: item,
                )));
      },
      child: Ink(
        color: Colors.grey[900],
        height: 105,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              width: 100,
              height: 100,
              child: Hero(
                tag: item.goodsId,
                child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrlList[0],
                      fit: BoxFit.cover,
                      memCacheHeight: 500,
                      filterQuality: FilterQuality.none,
                    )),
              ),
            ),
            Container(width: 15),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MakeContentText(item.title, Colors.white, 16),
                    Container(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MakeContentText(
                            RegionNCategory.regionList[item.regionId],
                            Colors.white70,
                            12),
                        MakeContentText(
                            "ㆍ" + RegionNCategory.categoryList[item.categoryId],
                            Colors.white70,
                            12),
                        MakeContentText(
                            "ㆍ" +
                                PassedTime.createPassedTime(
                                    currentTime, item.createdDate),
                            Colors.white70,
                            12),
                      ],
                    ),
                    Container(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MakeContentText(
                              numFormat.format(item.price), Colors.white, 16),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                LikeIcon(
                                  user: user,
                                  item: item,
                                  likeFunc: likeFunc,
                                  unlikeFunc: unlikeFunc,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                MakeContentText(
                                    "조회수 " + item.viewCount.toString(),
                                    Colors.grey,
                                    13),
                              ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Text 위젯을 만드는 코드의 중복을 피하기 위한 클래스
class MakeContentText extends StatelessWidget {
  const MakeContentText(this.text, this.color, this.fontsize);
  final String text;
  final Color color;
  final double fontsize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.abel(
          color: color, // Colors.white
          fontSize: fontsize, // 16
          wordSpacing: 0,
          letterSpacing: 1.0,
          fontWeight: FontWeight.bold),
    );
  }
}
