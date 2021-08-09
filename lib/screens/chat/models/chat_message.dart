import 'package:flutter/cupertino.dart';
import 'package:shop_directs/utils/enums.dart';


class ChatMessage{
  final String message;
  final String url;
  final ChatMessageType chatMessageType;
  final MessageFrom type;
  final DateTime dateTime;
  final bool isRead;
  final String sentBy;
  ChatMessage({
    this.message,
    this.isRead,
    this.url,
    @required this.chatMessageType,
    @required this.type,
    @required this.dateTime,
    @required this.sentBy});
}