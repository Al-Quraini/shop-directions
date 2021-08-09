import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shop_directs/cubit/internet_cubit/internet_cubit.dart';
import 'package:shop_directs/cubit/user/user_cubit.dart';
import 'package:shop_directs/dialogs/dialog_maker.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/screens/authentication_screens/login_screen.dart';
import 'package:shop_directs/screens/main/my_items_screen.dart';
import 'package:shop_directs/screens/profile_screen/profile_edit.dart';
import 'package:shop_directs/utils/size_config.dart';

class SettingsPage extends StatefulWidget {
  static const String id ='/settings_page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0xffcfdddd),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Settings',
                    style: TextStyle(
                        fontSize: getProportionateSize(25),
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {

                  return Expanded(
                    child: SettingsList(

                      sections: [
                        SettingsSection(
                          titlePadding: EdgeInsets.symmetric(vertical: getProportionateSize(10),
                              horizontal: getProportionateSize(15)),
                          title: 'Settings',

                          tiles: [
                            SettingsTile(
                              title: 'Language',
                              subtitle: 'English',
                              leading: Icon(Icons.language),
                              onPressed: (BuildContext context) {},
                            ),
                            SettingsTile.switchTile(
                              title: 'Dark Mode',
                              leading: Icon(Icons.lightbulb_outline),
                              switchValue: false,
                              onToggle: (bool value) {},
                            ),
                          ],
                        ),

                        SettingsSection(
                          titlePadding: EdgeInsets.symmetric(
                              vertical: getProportionateSize(10),
                              horizontal: getProportionateSize(15)),

                          title: 'Account',
                          tiles: state is UserLogged ?
                          currentUserLogged(state):
                          noUserLogged(),
                        ),
                      ],
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }

  List<SettingsTile> currentUserLogged(UserLogged state){
    final internetState =context.watch<InternetCubit>().state;

    return [
      SettingsTile(
        title: 'Edit Profile',
        // subtitle: 'English',
        leading: Icon(Icons.person),
        onPressed: (BuildContext context) async{

          var deleted =
          await Navigator.pushNamed(context, ProfileUpdate.id);

          // Future.delayed(Duration(microseconds: 500));

          if(deleted == true)
            BlocProvider.of<UserCubit>(context).emitUserNull();
        },
      ),
      SettingsTile(
        title: 'My Items',
        // subtitle: 'English',
        leading: Icon(Icons.view_list_sharp),
        onPressed: (BuildContext context) {
          Navigator.pushNamed(context, MyItemsScreen.id);
        },
      ),
      SettingsTile(
        title: 'Change Password',
        leading: Icon(Icons.vpn_key_sharp),
        // switchValue: true,
        onPressed: (BuildContext context) {},
      ),
      SettingsTile(
        title: 'Sign Out',
        leading: Icon(Icons.logout),
        // switchValue: true,
        onPressed: (BuildContext context) {
          if(state is UserLogged)
            DialogMaker(
                context: context,
                title: 'SIGN OUT',
                content: 'Are you sure you want to sign out ${state.user.name}?',
                onPress: (){
                  if(internetState is InternetConnected) {
                    FirebaseAuthClass().signOut();
                    context.read<UserCubit>().emitUserNull();
                  } else if (internetState is InternetDisconnected){
                    final snackBar = SnackBar(content:
                    Text('No internet connection'),
                      backgroundColor: Colors.red,
                      duration: Duration(milliseconds: 500),);
                    Scaffold.of(context).showSnackBar(snackBar);
                  }

                }
            ).displayDialog();
        },
      ),
    ];
  }

  List<SettingsTile> noUserLogged(){
    return [
      SettingsTile(
      title: 'Log in',
      // subtitle: 'English',
      leading: Icon(Icons.person),
      onPressed: (BuildContext context) async{
        Navigator.pushNamed(context, LoginScreen.id);
      },
    )];
  }
}
