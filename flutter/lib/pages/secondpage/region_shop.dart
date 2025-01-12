import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class RegionPageShop extends StatefulWidget {
  RegionPageShop(this.regionList);
  List<String>? regionList;

  @override
  _RegionPageShopState createState() => _RegionPageShopState();
}

class _RegionPageShopState extends State<RegionPageShop> {
  Map<String, bool> itemMap = {
    "서울": false,
    "경기남부": false,
    "경기북부": false,
    "강원도": false,
    "충청북도": false,
    "충청남도": false,
    "전라북도": false,
    "전라남도": false,
    "경상북도": false,
    "경상남도": false,
    "부산": false,
    "인천": false,
    "대구": false,
    "울산": false,
    "광주": false,
    "제주": false,
  };

  @override
  void initState() {
    super.initState();
    if (widget.regionList != null) {
      widget.regionList!.forEach((element) {
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
          GridViewContainer(keyName: "서울", itemMap: itemMap),
          GridViewContainer(keyName: "경기남부", itemMap: itemMap),
          GridViewContainer(keyName: "경기북부", itemMap: itemMap),
          GridViewContainer(keyName: "강원도", itemMap: itemMap),
          GridViewContainer(keyName: "충청북도", itemMap: itemMap),
          GridViewContainer(keyName: "충청남도", itemMap: itemMap),
          GridViewContainer(keyName: "전라북도", itemMap: itemMap),
          GridViewContainer(keyName: "전라남도", itemMap: itemMap),
          GridViewContainer(keyName: "경상북도", itemMap: itemMap),
          GridViewContainer(keyName: "경상남도", itemMap: itemMap),
          GridViewContainer(keyName: "부산", itemMap: itemMap),
          GridViewContainer(keyName: "인천", itemMap: itemMap),
          GridViewContainer(keyName: "대구", itemMap: itemMap),
          GridViewContainer(keyName: "울산", itemMap: itemMap),
          GridViewContainer(keyName: "광주", itemMap: itemMap),
          GridViewContainer(keyName: "제주", itemMap: itemMap),
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