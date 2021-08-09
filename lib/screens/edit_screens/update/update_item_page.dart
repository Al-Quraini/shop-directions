import 'package:flutter/material.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shop_directs/firebase/firebase_storage.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/screens/edit_screens/update/components/body_update.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_directs/widgets/rounded_button.dart';


class UpdateItemPage extends StatefulWidget {
  static const String id = '/add_item_page';

  final Item argument;

  UpdateItemPage({this.argument});

  @override
  _UpdateItemPageState createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends State<UpdateItemPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF2F2F2),

        body: Body(item: widget.argument,),
      ),
    );
  }
}
