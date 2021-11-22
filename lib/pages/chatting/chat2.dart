import 'dart:convert';
import 'dart:math';
import 'package:bikers/api/apiConfig.dart';
import 'package:bikers/api/chatpage/chatMessageApi.dart';
import 'package:bikers/api/chatpage/chatRoomApi.dart';
import 'package:bikers/shared/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// ignore: must_be_immutable
class Chat2 extends StatefulWidget {
  Chat2(
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
  _Chat2State createState() => _Chat2State();
}

class _Chat2State extends State<Chat2> with WidgetsBindingObserver {
  List<types.TextMessage> _messages = [];
  late types.User me;
  //late types.User you;
  late IO.Socket socket;
  String? joinedRoom;
  bool isRoomExist = false;
  bool futureInitCompleted = false;
  int memCount = 0;

  @override
  initState() {
    super.initState();
    me = types.User(id: widget.userId);
    //you = types.User(id: widget.sellerId);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _futureInit();
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('Current state = $state');
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        _futureInit();
        break;
      case AppLifecycleState.paused:
        if (isRoomExist) {
          socket.emit("leave", joinedRoom);
          socket.dispose();
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    if (isRoomExist) {
      socket.emit("leave", joinedRoom);
      socket.dispose();
    }
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void socketInit() {
    socket = IO.io(ApiConfig.apiUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });
    socket.onConnect((data) => print("Connected"));
    socket.on("message", (msg) {
      final textMessage = types.TextMessage(
        author: types.User(id: msg["writerId"]),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: msg["msg"],
        status: memCount == 2 ? types.Status.seen : types.Status.delivered,
      );
      _messages.insert(0, textMessage);
      setState(() {});
    });
    socket.on("joinCount", (msg) {
      memCount = msg["memCount"];
      if (memCount == 2) {
        changeMsgStateToSeen();
        setState(() {});
      }
    });
    socket.on("leaveCount", (_) {
      memCount--;
    });
    socket.onReconnect((data) => _futureInit());
    socket.onDisconnect((_) => print('disconnect'));
  }

  void changeMsgStateToSeen() {
    types.Status seen = types.Status.seen;
    int i = 0;
    int length = _messages.length;
    while (_messages[i].status != seen && i < length) {
      _messages[i] = _messages[i].copyWith(status: seen) as types.TextMessage;
      i++;
    }
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
    socket.emit(
        "message", {"room": joinedRoom, "writerId": widget.userId, "msg": msg});
    Map<String, String> body = {
      "room_id": joinedRoom!,
      "user_id": widget.userId,
      "contents": msg,
      "isviewed": memCount == 2 ? "0" : "1"
    };
    ChatMessage.postChatMessage(body);
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

  Future<ChatMessageList> getChatInShop(int goodsId, String userId) async {
    ChatMessageList chatMessageList =
        await ChatMessage.getChatInShop(goodsId, userId);
    if (chatMessageList.chatMessegeList.length != 0) {
      isRoomExist = true;
    }
    return chatMessageList;
  }

  types.TextMessage chatMsgToTextMsg(
      ChatMessage chatMessage, types.User author) {
    final textMessage = types.TextMessage(
        author: author,
        createdAt: chatMessage.createdDate.millisecondsSinceEpoch,
        id: randomString(),
        text: chatMessage.contents,
        status:
            chatMessage.isviewed == 1 ? types.Status.sent : types.Status.seen);
    return textMessage;
  }

  List<types.TextMessage> chatMsgListConvert(List<ChatMessage> chatMsgList) {
    List<types.TextMessage> convertedList = [];
    for (int i = 0; i < chatMsgList.length; i++) {
      types.TextMessage msg = chatMsgToTextMsg(
          chatMsgList[i], types.User(id: chatMsgList[i].writerId));
      convertedList.insert(0, msg);
    }
    return convertedList;
  }

  Future _futureInit() async {
    ChatMessageList list;
    if (widget.roomId != null) {
      list = await ChatMessage.getChatMessage(
          int.parse(widget.roomId!), widget.userId);
      _messages = chatMsgListConvert(list.chatMessegeList);
      isRoomExist = true;
    } else {
      list = await getChatInShop(widget.goodsId, widget.userId);
      _messages = chatMsgListConvert(list.chatMessegeList);
    }
    if (isRoomExist) {
      socketInit();
      join(list.chatMessegeList[0].roomId.toString());
    }
    setState(() {
      futureInitCompleted = true;
    });
  }

  // 꼭 필요한 것인가?
  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void _handleSendPressed(types.PartialText message) {
    postMessage(joinedRoom, message.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black54, title: Text("채팅방")),
      body: futureInitCompleted
          ? SafeArea(
              bottom: false,
              child: Chat(
                messages: _messages,
                dateHeaderThreshold: 300000,
                onSendPressed: _handleSendPressed,
                //bubbleBuilder: _bubbleBuilder,
                // showUserAvatars: true,
                // showUserNames: true,
                user: me,
                theme: DefaultChatTheme(backgroundColor: Colors.black),
              ),
            )
          : Loading(),
    );
  }
}
