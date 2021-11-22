import 'package:bikers/api/apiConfig.dart';
import 'package:bikers/api/chatpage/chatMessageApi.dart';
import 'package:bikers/api/chatpage/chatRoomApi.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// ignore: must_be_immutable
class ChattingPage extends StatefulWidget {
  ChattingPage(
      {Key? key,
      required this.goodsId,
      this.sellerId,
      this.roomId,
      required this.userId})
      : super(key: key);
  final int goodsId;
  String? sellerId;
  String? roomId;
  final String userId;

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  late IO.Socket socket;
  late TextEditingController textEditingController;
  late TextEditingController roomEditingController;
  String? joinedRoom;
  List<ChatMessage> chatMessageList = [];
  bool isRoomExist = false;

  @override
  initState() {
    super.initState();
    textEditingController = TextEditingController();
    roomEditingController = TextEditingController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _futureInit();
    });
  }

  @override
  void dispose() {
    if (isRoomExist) {
      socket.emit("leave", joinedRoom);
      socket.dispose();
    }
    textEditingController.dispose();
    roomEditingController.dispose();
    super.dispose();
  }

  void socketInit() {
    socket = IO.io(ApiConfig.apiUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect((data) => print("Connected"));
    socket.on("message", (msg) {
      // chatMessageList.add(msg["msg"]);
      chatMessageList.add(ChatMessage(
          roomId: int.parse(msg["room"]),
          writerId: msg["writerId"],
          contents: msg["msg"],
          isviewed: 0,
          createdDate: DateTime.now()));
      setState(() {});
    });
    socket.onDisconnect((_) => print('disconnect'));
  }

  void postMessage(room, msg) async {
    if (isRoomExist == false) {
      String roomId =
          await createChatRoom(widget.goodsId, widget.sellerId!, widget.userId);
      isRoomExist = true;
      joinedRoom = roomId;
      socketInit();
      join(roomId);
    }
    if (isRoomExist) {
      socket.emit("message",
          {"room": joinedRoom, "writerId": widget.userId, "msg": msg});
      Map<String, String> body = {
        "room_id": joinedRoom!,
        "user_id": widget.userId,
        "contents": msg
      };
      ChatMessage.postChatMessage(body);
    }
  }

  void join(String roomId) {
    joinedRoom = roomId;
    socket.emit("join", roomId);
  }

  Future<String> createChatRoom(
      int goodsId, String sellerId, String buyerId) async {
    Map<String, String> body = {
      "goods_id": goodsId.toString(),
      "seller_id": sellerId,
      "buyer_id": buyerId
    };
    String roomId = await ChatRoom.createChatRoom(body);
    return roomId;
  }

  Future getChatInShop(int goodsId, String userId) async {
    ChatMessageList chatMessageList =
        await ChatMessage.getChatInShop(goodsId, userId);
    if (chatMessageList.chatMessegeList.length != 0) {
      isRoomExist = true;
    }
    return chatMessageList.chatMessegeList;
  }

  Future _futureInit() async {
    if (widget.roomId != null) {
      ChatMessageList list = await ChatMessage.getChatMessage(
          int.parse(widget.roomId!), widget.userId);
      chatMessageList = list.chatMessegeList;
      isRoomExist = true;
    } else {
      chatMessageList = await getChatInShop(widget.goodsId, widget.userId);
    }
    if (isRoomExist) {
      socketInit();
      join(chatMessageList[0].roomId.toString());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: 50,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: textEditingController,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      postMessage(joinedRoom, textEditingController.text);
                    },
                    child: Text("send"))
              ],
            ),
          ),
          Container(
            height: 50,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: roomEditingController,
                  ),
                ),
                // TextButton(
                //     onPressed: () {
                //       joinChange(
                //           joinedRoom!, roomEditingController.text);
                //     },
                //     child: Text("join"))
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                  itemCount: chatMessageList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(chatMessageList[index].writerId),
                        subtitle: Text(chatMessageList[index].contents),
                      ),
                    );
                  }),
            ),
          )
        ])));
  }
}
