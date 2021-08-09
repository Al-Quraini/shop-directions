import 'package:flutter/material.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/chat/chat_detail_page.dart';
import 'package:shop_directs/screens/chat/models/chat_message.dart';
import 'package:shop_directs/utils/enums.dart';

class ChatUsersList extends StatefulWidget{
  final User user;
  final List<ChatMessage> chatMessages;
  ChatUsersList({
     this.user, this.chatMessages});
  @override
  _ChatUsersListState createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, ChatDetailPage.id, arguments: widget.user);
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: FadeInImage.assetNetwork(
                        placeholder: '/assets/images/place_holder.jpg',
                        image:widget.user.imageUrl
                        ).image,
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.user.name),
                          SizedBox(height: 6,),
                          Text( messageText(),style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.chatMessages.last.dateTime.toString(),style:
            TextStyle(fontSize: 12,color:
            widget.chatMessages.last.isRead && widget.chatMessages.last.sentBy
                == FirebaseAuthClass.currentUser.uid?
            Colors.pink:Colors.grey.shade500),),
          ],
        ),
      ),
    );
  }

  String messageText(){
    if (widget.chatMessages != null && widget.chatMessages.isNotEmpty)
    switch(widget.chatMessages.last.chatMessageType){
    case ChatMessageType.text :
      return widget.chatMessages.last.message;
      break;

      case ChatMessageType.image :
      return 'image 🌄';
      break;

      case ChatMessageType.audio :
          return 'voice message 🎤';
          break;

      case ChatMessageType.file:
        return 'file 🗂';
        break;
      default:
        return '';
    }
   if (widget.chatMessages.last.chatMessageType == ChatMessageType.text)
    return widget.chatMessages.last.message;

  else if (widget.chatMessages.last.chatMessageType == ChatMessageType.image)
    return 'image 🌄';

  else
    return 'voice message 🎤';

  }
}