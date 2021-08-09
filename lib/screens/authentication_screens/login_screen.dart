import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shop_directs/cubit/user/user_cubit.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/firebase/firestore/firestore_read.dart';
import 'package:shop_directs/main.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/authentication_screens/authentication_widgets/build_container.dart';
import 'package:shop_directs/screens/authentication_screens/authentication_widgets/build_logo.dart';
import 'package:shop_directs/screens/authentication_screens/registeration_screen.dart';
import 'package:shop_directs/utils/constants.dart';
import 'package:shop_directs/utils/enums.dart';
import 'package:shop_directs/utils/size_config.dart';
import 'package:shop_directs/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main/items_screen.dart';

typedef void EmailCallback(String val);


class LoginScreen extends StatefulWidget  {
  static const String id = '/loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  String email;
  String password;
  User user;
  bool showSpinner=false;

  void loginSuccess() async{
    //user = await FirebaseFirestoreClass().loadUserData();
    //Navigator.popAndPushNamed(context, '/items_screen', arguments: user);
    await loadData();
    print('emaaaaaaaaaaaaaai ${user.email}');

    context.read<UserCubit>().emitUserLogged(user);
    // Navigator.popAndPushNamed(context, ItemsScreen.id);
    Navigator.pop(context);
  }

  void loginUser() async{
    //BlocProvider.of<CounterCubit>(context).showSpinner();
    setState(() {
      showSpinner=true;
    });
    var loggedUser =await FirebaseAuthClass().loginUser(email, password,);

    if(loggedUser != null)
      loginSuccess();

    //BlocProvider.of<CounterCubit>(context).hideSpinner();
    setState(() {
      showSpinner=false;
    });

  }

  Future<void> loadData() async{
    print('meeeeeeeeeeeeeeeeeeeeeeeeeeem1');
    this.user = await FirebaseFirestoreRead().loadUserData(
        userUid: FirebaseAuthClass.getCurrentUserUid()
    );

  }

  void setPassword(String value){
    this.password= value;
  }

  void setEmail(String value){
    this.email= value;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('login Screen'),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white70,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height*0.7,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(getProportionateSize(70)),
                        bottomRight: Radius.circular(getProportionateSize(70))
                    )
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BuildLogo(),
                  BuildContainer(
                    authPage: AuthPage.LoginPage,
                    label: 'Login',
                   authFunction: loginUser,
                  emailCallback: (value) => email =value,
                  passwordFunction: setPassword,
                    cardRatio: 0.6,
                  ),
                  _buildSignUpBtn(),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom,
                  ),
                ],
              )
            ],
          ),
        ),

      ),
      ),
    );
  }

  Widget _buildSignUpBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: getProportionateSize(40),bottom:
          getProportionateSize(25)),
          child:  RichText(
          textAlign: TextAlign.center,
            text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
            TextSpan(text: 'You don\'t have an account with us? ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height / 60,
                  fontWeight: FontWeight.w400,
                )),
            TextSpan(
            text: 'Sign up here',
            style: TextStyle(color: mainColor,
              fontSize: MediaQuery.of(context).size.height / 60,
              fontWeight: FontWeight.bold,),
            recognizer: TapGestureRecognizer()
            ..onTap = () {
            Navigator.pushNamed(context, RegisterScreen.id);
            print('Terms of Service"');
    }),
        ]),

    )
    )
    ]);
  }



}

