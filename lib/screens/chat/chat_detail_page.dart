import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/firebase/firestore/firestore_read.dart';
import 'package:shop_directs/firebase/firestore/firestore_streams.dart';
import 'package:shop_directs/firebase/firestore/firestore_write.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/chat/components/chat_input_field.dart';
import 'package:shop_directs/screens/chat/models/send_menu_items.dart';
import 'package:shop_directs/utils/enums.dart';
import 'components/chat_detail_page_appbar.dart';
import 'components/chat_bubble.dart';
import 'components/detail_chat_body.dart';
import 'models/chat_message.dart';



class ChatDetailPage extends StatefulWidget{
  static const String id ='/ChatDetailPage';
  final User argument;

  const ChatDetailPage({Key key, this.argument}) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatDetailPageAppBar(user : widget.argument),
      body: Body(user: widget.argument,)
    );
  }
}




