import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CategoryPageShop extends StatefulWidget {
  CategoryPageShop(this.categoryList);
  List<String>? categoryList;

  @override
  _CategoryPageShopState createState() => _CategoryPageShopState();
}

class _CategoryPageShopState extends State<CategoryPageShop> {
  Map<String, bool> itemMap = {
    "125cc 미만": false,
    "125cc 이상": false,
    "안전장비": false,
    "튜닝용품": false,
    "헬멧": false,
    "블루투스": false,
    "마스크": false,
    "자켓": false,
    "글러브": false,
    "팬츠": false,
    "부츠": false,
    "블랙박스": false,
    "슈트": false,
    "기타용품": false,
  };

  @override
  void initState() {
    super.initState();
    if (widget.categoryList != null) {
      widget.categoryList!.forEach((element) {
        itemMap[element] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '카테고리 설정',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
              onPressed: () {
                List<String> nameList = [];
                itemMap.forEach((key, value) {
                  if (value == true) {
                    nameList.add(key);
                  }
                });
                Navigator.of(context).pop(nameList);
              },
              child: Text(
                '확인',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 3 / 1,
        padding: EdgeInsets.fromLTRB(20, 5, 20, 30),
        children: <Widget>[
          GridViewContainer(keyName: "125cc 미만", itemMap: itemMap),
          GridViewContainer(keyName: "125cc 이상", itemMap: itemMap),
          GridViewContainer(keyName: "안전장비", itemMap: itemMap),
          GridViewContainer(keyName: "튜닝용품", itemMap: itemMap),
          GridViewContainer(keyName: "헬멧", itemMap: itemMap),
          GridViewContainer(keyName: "블루투스", itemMap: itemMap),
          GridViewContainer(keyName: "마스크", itemMap: itemMap),
          GridViewContainer(keyName: "자켓", itemMap: itemMap),
          GridViewContainer(keyName: "글러브", itemMap: itemMap),
          GridViewContainer(keyName: "팬츠", itemMap: itemMap),
          GridViewContainer(keyName: "부츠", itemMap: itemMap),
          GridViewContainer(keyName: "블랙박스", itemMap: itemMap),
          GridViewContainer(keyName: "슈트", itemMap: itemMap),
          GridViewContainer(keyName: "기타용품", itemMap: itemMap),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class GridViewContainer extends StatefulWidget {
  GridViewContainer({required this.keyName, required this.itemMap});
  String keyName;
  Map<String, bool> itemMap;

  @override
  _GridViewContainerState createState() => _GridViewContainerState();
}

class _GridViewContainerState extends State<GridViewContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          widget.keyName,
          style: GoogleFonts.alata(
              color: Colors.black, fontWeight: FontWeight.w500),
          textAlign: TextAlign.start,
        ),
        checkColor: Colors.black,
        activeColor: Colors.white,
        tileColor: Colors.black,
        contentPadding: EdgeInsets.only(left: 5, right: 5),
        value: widget.itemMap[widget.keyName],
        onChanged: (value) {
          setState(() {
            if (value != null) {
              widget.itemMap[widget.keyName] = value;
            }
          });
        },
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
    );
  }
}