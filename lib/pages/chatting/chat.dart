import 'package:bikers/pages/chatting/chatController.dart';
import 'package:bikers/shared/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  ChatPage(
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
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  late types.User me;
  late ChatController _chatController;

  @override
  initState() {
    super.initState();
    me = types.User(id: widget.userId);

    _chatController = Get.put(ChatController(
        goodsId: widget.goodsId,
        sellerId: widget.sellerId,
        roomId: widget.roomId,
        userId: widget.userId));

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _chatController.futureInit();
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    super.didChangeAppLifecycleState(state);
    print('Current state = $state');
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        await _chatController.reConnectHandler();
        break;
      case AppLifecycleState.paused:
        if (_chatController.isRoomExist) {
          _chatController.socket.emit("leave", _chatController.joinedRoom);
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    if (_chatController.isRoomExist) {
      _chatController.socket.emit("leave", _chatController.joinedRoom);
      _chatController.socket.dispose();
    }
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _handleSendPressed(types.PartialText message) {
    _chatController.postMessage(_chatController.joinedRoom, message.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black54, title: Text("채팅방")),
      body: GetBuilder<ChatController>(
        builder: (_) => _chatController.futureInitCompleted
            ? SafeArea(
                bottom: false,
                child: Chat(
                  messages: _chatController.messages,
                  dateHeaderThreshold: 300000,
                  onSendPressed: _handleSendPressed,
                  // bubbleBuilder: _bubbleBuilder,
                  // showUserAvatars: true,
                  // showUserNames: true,
                  user: me,
                  theme: DefaultChatTheme(backgroundColor: Colors.black),
                ),
              )
            : Loading(),
      ),
    );
  }
}
