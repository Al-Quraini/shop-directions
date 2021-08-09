import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_directs/cubit/scrroll/scroll_cubit.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/life_cycle.dart';
import 'package:shop_directs/screens/authentication_screens/login_screen.dart';
import 'package:shop_directs/screens/host_screen/host_page.dart';
import 'package:shop_directs/screens/main/items_screen.dart';
import 'package:shop_directs/cubit/counter/counter_cubit.dart';
import 'package:shop_directs/utils/size_config.dart';
import 'cubit/counter/counter_cubit.dart';
import 'cubit/internet_cubit/internet_cubit.dart';
import 'cubit/user/user_cubit.dart';

import 'package:shop_directs/router/app_router.dart';



void main() async{

  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();



  runApp(MyApp(
    connectivity: Connectivity(),
  ));
}

class MyApp extends StatelessWidget{
  final Connectivity connectivity;

  const MyApp({
    Key key,
    @required this.connectivity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final AppRouter _appRouter=AppRouter();

    return MultiBlocProvider(


          providers: [

            BlocProvider<CounterCubit>(
              create:  (context) => CounterCubit(),
            )
            ,
            BlocProvider<InternetCubit>(
              create:  (context) => InternetCubit(connectivity: connectivity),
            )
            ,


            BlocProvider(
              create:  (context) => ScrollCubit(),
            )
            ,
            BlocProvider(
              create:  (context) =>
                  UserCubit(userStream: FirebaseAuthClass().getUser())),


          ],
          child: MaterialApp(
            // title: 'My shop',
            initialRoute: HostPage.id,
            //ItemsScreen.id ,
            onGenerateRoute: _appRouter.onGenerateRoute,

          ),

        );

  }

}



