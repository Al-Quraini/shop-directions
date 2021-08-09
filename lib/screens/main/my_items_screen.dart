import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shop_directs/cubit/internet_cubit/internet_cubit.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/firebase/firestore/firestore_read.dart';
import 'package:shop_directs/firebase/firestore/firestore_streams.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/edit_screens/update/update_item_page.dart';
import 'package:shop_directs/screens/main/components/items_stream.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:shop_directs/utils/enums.dart';
import 'package:shop_directs/utils/size_config.dart';

import 'components/my_items_stream.dart';

class MyItemsScreen extends StatefulWidget  {
  static const String id = '/my_items_screen';

  @override
  _MyItemsScreenState createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  User user ;

  bool showSpinner = false;

  void loadData() async{
    setState(() {
      showSpinner =true;
    });

    this.user = await FirebaseFirestoreRead().loadUserData(
      userUid: FirebaseAuthClass.getCurrentUserUid()
    );

    setState(() {
      showSpinner =false;
    });

  }

  @override
  void initState(){

    // loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: buildAppBar(),
        body: SafeArea(
          child: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: BlocBuilder<InternetCubit, InternetState>(
                builder: (context, state) {
                  if(state is InternetConnected)
                  return MyItemsStream(
                    stream: FirebaseFirestoreStream().getCurrentUserItemsStream(),
                    des: UpdateItemPage.id,
                  );
                  else if(state is InternetDisconnected)
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.exclamation,
                            color: Colors.red,
                          ),
                          Text('Connection Failed')
                        ],
                      ),
                    );
                  else return CircularProgressIndicator();
                }
              )
          ),
        ),

      );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      elevation: 0,

      actions: <Widget>[
        IconButton(
        icon: Icon(Icons.access_alarms_sharp,
          color: Colors.white12,
          ),
          onPressed: () {},
        ),
        SizedBox(width: kDefaultPadding / 2)
      ],
    );
  }
}






