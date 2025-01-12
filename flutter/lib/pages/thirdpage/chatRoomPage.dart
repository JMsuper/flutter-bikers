import 'package:bikers/api/chatpage/chatRoomApi.dart';
import 'package:bikers/authentication/user.dart';
import 'package:bikers/home/home.dart';
import 'package:bikers/pages/chatting/chat.dart';
import 'package:bikers/shared/passedTime.dart';
import 'package:bikers/shared/widget/loading.dart';
import 'package:bikers/shared/widget/speedDial.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late ChatRoomList chatRoomList;
  dynamic user;
  late DateTime now;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<Users?>(context);
  }

  Future initFuture() async {
    chatRoomList = await ChatRoom.getChatRoom(user.uid);
    return chatRoomList.chatRoomList;
  }

  @override
  Widget build(BuildContext context) {
    now = DateTime.now();
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
              onPressed: () {
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: initFuture(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ChatRoom> chatRoomList = snapshot.data as List<ChatRoom>;
              return ListView.builder(
                  itemCount: chatRoomList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[100],
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ChatPage(
                              goodsId: chatRoomList[index].goodsId,
                              roomId: chatRoomList[index].roomId.toString(),
                              userId: user.uid));
                        },
                        child: ListTile(
                          title: Text(chatRoomList[index].nickName),
                          leading: chatRoomList[index].imageUrl == null
                              ? CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.black,
                                  backgroundImage:
                                      AssetImage('assets/profileImage.jpg'),
                                )
                              : CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.black,
                                  backgroundImage: CachedNetworkImageProvider(
                                    chatRoomList[index].imageUrl!,
                                  ),
                                ),
                          subtitle: Text(
                            chatRoomList[index].contents,
                          ),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            chatRoomList[index].notViewed != null
                                ? Container(
                                    child: Text(
                                      chatRoomList[index].notViewed.toString(),
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  )
                                : Container(),
                            SizedBox(width: 30),
                            Text(PassedTime.createPassedTime(
                                now, chatRoomList[index].createdDate)),
                          ]),
                        ),
                      ),
                    );
                  });
            } else {
              return Loading();
            }
          },
        ),
        floatingActionButton: MakeSpeedDial(
          heroTag: "third",
        ));
  }
}
