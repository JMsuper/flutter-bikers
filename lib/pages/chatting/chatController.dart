import 'dart:convert';
import 'dart:math';
import 'package:bikers/api/apiConfig.dart';
import 'package:bikers/api/chatpage/chatMessageApi.dart';
import 'package:bikers/api/chatpage/chatRoomApi.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  ChatController({
    required this.goodsId,
    required this.userId,
    this.sellerId,
    this.roomId,
  });

  List<types.TextMessage> messages = [];
  String? joinedRoom;
  bool isRoomExist = false;
  bool futureInitCompleted = false;
  late IO.Socket socket;
  final int goodsId;
  String? sellerId;
  String? roomId;
  final String userId;

  Future futureInit() async {
    ChatMessageList list = await getChat();
    if (isRoomExist) {
      socketInit(userId);
      join(list.chatMessegeList[0].roomId.toString());
      socket.emit("seen", {});
    }
    futureInitCompleted = true;
    update();
  }

  Future reConnectHandler() async {
    await getChat();
    socket.emit("seen", {});
    if (joinedRoom != null) join(joinedRoom!);
    update();
  }

  Future getChat() async {
    ChatMessageList list;
    // roomId가 null일 경우는 shop페이지에서 채팅방으로 들어온 경우이다.
    if (roomId != null) {
      list = await ChatMessage.getChatMessage(int.parse(roomId!), userId);
      messages = chatMsgListConvert(list.chatMessegeList);
      isRoomExist = true;
    } else {
      list = await ChatMessage.getChatInShop(goodsId, userId);
      if (list.chatMessegeList.length != 0) isRoomExist = true;
      messages = chatMsgListConvert(list.chatMessegeList);
    }
    return list;
  }

  void socketInit(String userId) {
    socket = IO.io(ApiConfig.apiUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });
    socket.onConnect((data) => print("Connected"));
    socket.on("message", (msg) {
      socket.emit("seen", {"room": joinedRoom, "userId": userId});
      addMsgToList(msg["writerId"], msg["msg"]);
      update();
    });

    //ERROR : setState() called after dispose()
    //solution is to check the "mounted" property of this object
    //before calling setState() to ensure the object is still in the tree.
    socket.on("seen", (data) {
      print("seen");
      changeMsgState(types.Status.sent, null);
      update();
    });

    socket.onReconnect((data) async {
      print(data.toString());
      await reConnectHandler();
    });
    socket.onDisconnect((_) => print('disconnect'));
  }

  void changeMsgState(types.Status beforeStatus, types.Status? afterStatus) {
    int i = 0;
    int length = messages.length;
    while ((messages[i].author.id != userId ||
            messages[i].status == beforeStatus) &&
        i < length) {
      if (messages[i].author.id == userId) {
        types.TextMessage temp = types.TextMessage(
            author: messages[i].author,
            createdAt: messages[i].createdAt,
            text: messages[i].text,
            id: messages[i].id,
            status: afterStatus);
        messages[i] = temp;
      }
      i++;
    }
  }

  void postMessage(room, msg) async {
    if (isRoomExist == false) {
      String roomId = await createChatRoom(goodsId, sellerId!, userId);
      isRoomExist = true;
      joinedRoom = roomId;
      socketInit(userId);
      join(roomId);
    }
    addMsgToList(userId, msg);
    update();
    socket.emitWithAck(
        "message", {"room": joinedRoom, "writerId": userId, "msg": msg},
        ack: (response) {
      if (response["status"] == "success") {
        changeMsgState(types.Status.sending, types.Status.sent);
        update();
      }
    });
  }

  void addMsgToList(String writerId, String msg) {
    final textMessage = types.TextMessage(
      author: types.User(id: writerId),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: msg,
      status: types.Status.sending,
    );
    messages.insert(0, textMessage);
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
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

  types.TextMessage chatMsgToTextMsg(
      ChatMessage chatMessage, types.User author) {
    final textMessage = types.TextMessage(
        author: author,
        createdAt: chatMessage.createdDate.millisecondsSinceEpoch,
        id: randomString(),
        text: chatMessage.contents,
        status: chatMessage.isviewed == 1 ? types.Status.sent : null);
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
}
