import 'package:bikers/pages/fourthpage/feedshoptourPage/sold.dart';
import 'package:bikers/pages/fourthpage/feedshoptourPage/selling.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  @override
  State<ShopPage> createState() => _ShopPage();
}

class _ShopPage extends State<ShopPage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          '나의 판매글',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            tabs: <Tab>[
              Tab(
                text: '판매중',
              ),
              Tab(
                text: '판매완료',
              ),
            ],
            controller: tabController,
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[Selling(), Sold()],
              controller: tabController,
            ),
          ),
        ],
      ),
    );
  }
}
