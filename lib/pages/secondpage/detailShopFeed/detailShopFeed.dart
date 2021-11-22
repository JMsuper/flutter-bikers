import 'package:bikers/api/secondpage/shopApi.dart';
import 'package:bikers/authentication/user.dart';
import 'package:bikers/pages/chatting/chat.dart';
import 'package:bikers/pages/secondpage/regionAndCategory.dart';
import 'package:bikers/shared/widget/likeIcon.dart';
import 'package:bikers/shared/passedTime.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailShopFeed extends StatefulWidget {
  const DetailShopFeed({Key? key, required this.item}) : super(key: key);
  final Shop item;

  @override
  _DetailShopFeedState createState() => _DetailShopFeedState();
}

class _DetailShopFeedState extends State<DetailShopFeed>
    with SingleTickerProviderStateMixin {
  late Size size;
  var imageurl;
  List<Widget> carouselItemList = [];
  var _current;
  double _scrollPositionToAppBar = 0;
  ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation _colorTween;
  var numFormat = NumberFormat("###,###,###,###원");
  DateTime currentTime = DateTime.now();
  dynamic user;
  bool isFirstCall = true;

  @override
  void initState() {
    super.initState();
    _current = 0;
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);
    _scrollController.addListener(() {
      if (_scrollController.offset < 255) {
        setState(() {
          _scrollPositionToAppBar = _scrollController.offset;
          _animationController.value = _scrollPositionToAppBar / 255;
        });
      }
      print(_scrollController.offset);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirstCall) {
      user = Provider.of<Users?>(context);
      size = MediaQuery.of(context).size;
      for (int i = 0; i < widget.item.imageUrlList.length; i++) {
        carouselItemList.add(CachedNetworkImage(
          imageUrl: widget.item.imageUrlList[i],
          width: size.width,
          height: size.width,
          fit: BoxFit.cover,
        ));
      }
      isFirstCall = false;
    }
  }

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

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Icon(
        icon,
        color: _colorTween.value,
      ),
    );
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(_scrollPositionToAppBar.toInt()),
      toolbarHeight: 50,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: _makeIcon(Icons.arrow_back)),
      actions: [
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.share)),
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.more_vert)),
      ],
    );
  }

  Widget _scrollableImageView() {
    return Stack(children: [
      Container(
        child: CarouselSlider(
          options: CarouselOptions(
              height: size.width,
              initialPage: 0,
              enableInfiniteScroll: false,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                _current = index;
                setState(() {});
              }),
          items: carouselItemList,
        ),
      ),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: carouselItemList.length != 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: carouselItemList.map((element) {
                    var index = carouselItemList.indexOf(element);
                    return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ));
                  }).toList(),
                )
              : Container())
    ]);
  }

  Widget _contentsView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(children: [
        Container(
          width: size.width,
          height: 100,
          color: Colors.white,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.title,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    numFormat.format(widget.item.price),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    RegionNCategory.regionList[widget.item.regionId] +
                        "ㆍ" +
                        RegionNCategory.categoryList[widget.item.categoryId] +
                        "ㆍ" +
                        PassedTime.createPassedTime(
                            currentTime, widget.item.createdDate),
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ]),
            Column(
              children: [
                LikeIcon(
                  user: user,
                  item: widget.item,
                  likeFunc: likeFunc,
                  unlikeFunc: unlikeFunc,
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => ChatPage(
                        goodsId: widget.item.goodsId,
                        sellerId: widget.item.writerId,
                        userId: user.uid));
                  },
                  child: Text("거래하기"),
                )
              ],
            )
          ]),
        ),
        Divider(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Container(
            width: size.width,
            color: Colors.white,
            child: Text(widget.item.contents),
          ),
        ),
        Divider(
          height: 5,
        ),
      ]),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate(
                [_scrollableImageView(), _contentsView()]))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      backgroundColor: Colors.white,
    );
  }
}
