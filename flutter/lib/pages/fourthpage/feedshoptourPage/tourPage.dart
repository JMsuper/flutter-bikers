import 'package:flutter/material.dart';

class TourPage extends StatefulWidget {
  const TourPage({ Key? key }) : super(key: key);

  @override
  _TourPageState createState() => _TourPageState();
}

class _TourPageState extends State<TourPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('나의 투어글'),
        centerTitle: true,
      ),
     
    );
  }
}