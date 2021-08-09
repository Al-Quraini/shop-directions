import 'package:flutter/material.dart';

import 'package:shop_directs/screens/authentication_screens/registeration_screen.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:shop_directs/utils/enums.dart';
import 'package:shop_directs/utils/size_config.dart';
import 'package:shop_directs/widgets/input_components/build_auth_button.dart';
import 'package:shop_directs/widgets/input_components/build_email_row.dart';
import 'package:shop_directs/widgets/input_components/build_location_row.dart';
import 'package:shop_directs/widgets/input_components/build_name_row.dart';
import 'package:shop_directs/widgets/input_components/build_passowrd_row.dart';
import 'package:shop_directs/widgets/input_components/build_phone_row.dart';


class BuildContainer extends StatelessWidget {
  final EmailCallback emailCallback;
  final Function passwordFunction;
  final PhoneNumberCallback phoneCallback;
  final NameCallback nameCallback;
  final Function authFunction;
  final String label;
  final AuthPage authPage;
  final double cardRatio;
  final Widget profileImage;
  final LocationCallback locationCallback;

  BuildContainer({
    this.passwordFunction,
    this.authFunction,
    this.label,
    this.authPage,
    this.cardRatio,
    this.profileImage,
    this.locationCallback,
    this.emailCallback,
    this.phoneCallback,
    this.nameCallback});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: getProportionateSize(30)),
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 30,
                        ),
                      ),
                    ],
                  ),
                  if(authPage == AuthPage.LoginPage)
                  ...loginWidgets()
                  else if(authPage == AuthPage.RegistrationPage)
                  ...registerWidgets()
                  ,
                  BuildAuthButton(onPressed: authFunction, label: label,),




                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildForgetPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          onPressed: () {},
          child: Text("Forgot Password"),
        ),
      ],
    );
  }

  List<Widget> loginWidgets(){
    return [
      BuildEmailRow(callback: emailCallback,),
      BuildPasswordRow(onChange: passwordFunction,),
      _buildForgetPasswordButton(),
    ];
  }
  List<Widget> registerWidgets(){
    return [
      profileImage,
      BuildNameRow(callback: nameCallback,),
      BuildEmailRow(callback: emailCallback,),
      BuildPasswordRow(onChange: passwordFunction,),
      BuildPhoneRow(callback: phoneCallback,),
      BuildLocationRow(callback: locationCallback,),
      SizedBox(height: 20,)
    ];
  }
}
