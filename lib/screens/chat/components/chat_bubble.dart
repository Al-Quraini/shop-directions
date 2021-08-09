
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:shop_directs/screens/chat/chat_detail_page.dart';
import 'package:shop_directs/screens/chat/components/audio_message.dart';
import 'package:shop_directs/screens/chat/components/image_message.dart';

import 'package:shop_directs/screens/chat/models/chat_message.dart';
import 'package:shop_directs/utils/enums.dart';

import 'file_message.dart';

class ChatBubble extends StatelessWidget {
  final bool lastInGroup;
  final MessageFrom messageType;
  final ChatMessage chatMessages;

  const ChatBubble({
    Key key,
    @required this.chatMessages, this.lastInGroup, this.messageType,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.now();
    dt.compareTo(DateTime.now());
    return
    Bubble(
      // stick: true,
      nip: messageType == MessageFrom.Sender ?
      lastInGroup ? BubbleNip.rightBottom : BubbleNip.no :
      lastInGroup ? BubbleNip.leftBottom : BubbleNip.no
      ,
      color: messageType == MessageFrom.Sender ? 
      Color.fromRGBO(225, 255, 99, 1.0) :
      Color.fromRGBO(255, 255, 200, 0.99),
      margin: lastInGroup ? BubbleEdges.symmetric(horizontal: 9, vertical: 2):
        BubbleEdges.symmetric(horizontal: 16, vertical: 2),
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.15,
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          minHeight: MediaQuery.of(context).size.width * 0.06
        ),
        child: messageContaint(),
      ),
      alignment: messageType == MessageFrom.Sender ?
      Alignment.topRight :
      Alignment.topLeft,
      elevation: 3,

    );
  }

  Widget messageContaint() {
    switch (chatMessages.chatMessageType) {
      case ChatMessageType.text:
        return Text(chatMessages.message,
          style: TextStyle(
            // color: Colors.white
          ),);
        break;
      case ChatMessageType.audio:
        return AudioMessage(message: chatMessages);
        break;
      case ChatMessageType.image:
        return ImageMessage(chatMessage: chatMessages,);
        break;

        case ChatMessageType.file:
        return FileMessage(chatMessage: chatMessages,);
        break;
      default:
        return SizedBox();
    }
  }
}