import 'package:bikers/api/firstpage/feedApi.dart';
import 'package:bikers/authentication/user.dart';
import 'package:bikers/shared/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'FeedContent.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllFeedPage extends StatefulWidget {
  _AllFeedPageState createState() => _AllFeedPageState();
}

class _AllFeedPageState extends State<AllFeedPage>
    with TickerProviderStateMixin {
  Feed? _lastDocument;
  final PagingController _pagingController = PagingController(firstPageKey: 0);
  int _pageSize = 4;
  late Size size;
  dynamic user;
  late AnimationController _anicontroller, _scaleController;
  RefreshController _refreshController = RefreshController();

  late DateTime currentTime;

  Future _refreshList() async {
    currentTime = DateTime.now();
    _lastDocument = null;
    _pagingController.refresh();
    _refreshController.refreshCompleted();
  }

  _getProducts() async {
    if (_lastDocument == null) {
      FeedList feedList = await Feed.getFeedLatest(user.uid, _pageSize);
      int listLength = feedList.feedList.length;
      _lastDocument = feedList.feedList[listLength - 1];
      return feedList;
    } else {
      FeedList feedList = await Feed.getFeedLatestBeforeId(
          _lastDocument!.id, user.uid, _pageSize);
      int listLength = feedList.feedList.length;
      _lastDocument = feedList.feedList[listLength - 1];
      return feedList;
    }
  }

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    // AnimationController의 duration > 0이 아니면 에러 발생한다.
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
    size = MediaQuery.of(context).size;
    user = Provider.of<Users?>(context);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      FeedList? newItems = await _getProducts();
      if (newItems != null) {
        final isLastPage = newItems.feedList.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems.feedList);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems.feedList, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _refreshList,
      child: PagedListView.separated(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Feed>(
            itemBuilder: (BuildContext context, dynamic item, int index) {
              return Content(
                item: item,
                size: size,
                currentTime: currentTime,
                user: user,
              );
            },
            firstPageProgressIndicatorBuilder: (_) => Loading()),
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 30,
          );
        },
      ),
      header: CustomHeader(
        completeDuration: Duration(),
        refreshStyle: RefreshStyle.Behind,
        onOffsetChange: (offset) {
          if (_refreshController.headerMode!.value != RefreshStatus.refreshing)
            _scaleController.value = offset / 80.0;
        },
        builder: (_, __) {
          return Container(
            child: FadeTransition(
              opacity: _scaleController,
              child: ScaleTransition(
                child: SpinKitChasingDots(
                  size: 30.0,
                  color: Colors.white,
                ),
                scale: _scaleController,
              ),
            ),
            alignment: Alignment.center,
          );
        },
      ),
    );
  }
}
