import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingPageShop extends StatefulWidget {
  const SettingPageShop({Key? key}) : super(key: key);

  @override
  _SettingPageShopState createState() => _SettingPageShopState();
}

class _SettingPageShopState extends State<SettingPageShop> {
  bool motorcycleValue = false;
  bool motorcycleValue2 = false;
  bool gearValue = false;
  bool tuningValue = false;
  bool helmetValue = false;
  bool bluetoothValue = false;
  bool maskValue = false;
  bool jacketValue = false;
  bool gloveValue = false;
  bool pantsValue = false;
  bool bootsValue = false;
  bool blackboxValue = false;
  bool suitValue = false;
  bool etcValue = false;
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
              onPressed: () {},
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
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '125cc 미만',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: motorcycleValue,
              onChanged: (value) {
                setState(() {
                  motorcycleValue = !motorcycleValue;
                });
                print(motorcycleValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '125cc 이상',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: motorcycleValue2,
              onChanged: (value) {
                setState(() {
                  motorcycleValue2 = !motorcycleValue2;
                });
                print(motorcycleValue2);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '안전장비',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: gearValue,
              onChanged: (value) {
                setState(() {
                  gearValue = !gearValue;
                });
                print(gearValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '튜닝용품',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: tuningValue,
              onChanged: (value) {
                setState(() {
                  tuningValue = !tuningValue;
                });
                print(tuningValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '헬멧',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: helmetValue,
              onChanged: (value) {
                setState(() {
                  helmetValue = !helmetValue;
                });
                print(helmetValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '블루투스',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: bluetoothValue,
              onChanged: (value) {
                setState(() {
                  bluetoothValue = !bluetoothValue;
                });
                print(bluetoothValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '마스크',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: maskValue,
              onChanged: (value) {
                setState(() {
                  maskValue = !maskValue;
                });
                print(maskValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '자켓',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: jacketValue,
              onChanged: (value) {
                setState(() {
                  jacketValue = !jacketValue;
                });
                print(jacketValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '글러브',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: gloveValue,
              onChanged: (value) {
                setState(() {
                  gloveValue = !gloveValue;
                });
                print(gloveValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '팬츠',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: pantsValue,
              onChanged: (value) {
                setState(() {
                  pantsValue = !pantsValue;
                });
                print(pantsValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '부츠',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: bootsValue,
              onChanged: (value) {
                setState(() {
                  bootsValue = !bootsValue;
                });
                print(bootsValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '블랙박스',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: blackboxValue,
              onChanged: (value) {
                setState(() {
                  blackboxValue = !blackboxValue;
                });
                print(blackboxValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '슈트',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: suitValue,
              onChanged: (value) {
                setState(() {
                  suitValue = !suitValue;
                });
                print(suitValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '기타용품',
                style: GoogleFonts.alata(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              checkColor: Colors.black,
              activeColor: Colors.white,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              value: etcValue,
              onChanged: (value) {
                setState(() {
                  etcValue = !etcValue;
                });
                print(etcValue);
              },
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
        ],
      ),
    );
  }
}
