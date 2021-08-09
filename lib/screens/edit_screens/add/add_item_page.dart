import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shop_directs/firebase/firebase_storage.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_directs/widgets/rounded_button.dart';

import 'components/body.dart';


class AddItemPage extends StatefulWidget {
  static const String id = '/update_item_page';

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),


      body: SafeArea(child: Body()),
    );
  }
}
