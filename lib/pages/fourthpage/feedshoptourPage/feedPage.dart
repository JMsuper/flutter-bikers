import 'package:bikers/shared/widget/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final _firestore = FirebaseFirestore.instance;

  _getProducts() async {
    Query q =
        _firestore.collection("feedContents").orderBy("date", descending: true);
    QuerySnapshot querySnapshot = await q.get();
    return querySnapshot.docs;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '나의 게시물',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _getProducts(),
          builder: (context, AsyncSnapshot snapshot) {
            final List<DocumentSnapshot>? list = snapshot.data;
            if (list != null) {
              return SafeArea(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                    // childAspectRatio: 3 / 2,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return GridTile(
                      child: InkWell(
                        onTap: () {
                          
                        },
                                              child: CachedNetworkImage(
                          imageUrl: list[index]["imagesUrl"][0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Loading();
            }
          }),
    );
  }
}