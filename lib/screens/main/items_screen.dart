import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shop_directs/cubit/internet_cubit/internet_cubit.dart';
import 'package:shop_directs/cubit/scrroll/scroll_cubit.dart';
import 'package:shop_directs/cubit/user/user_cubit.dart';
import 'package:shop_directs/firebase/firebase_storage.dart';
import 'package:shop_directs/firebase/firestore/firestore_read.dart';
import 'package:shop_directs/firebase/firestore/firestore_streams.dart';
import 'package:shop_directs/screens/detail/detail_page.dart';
import 'package:shop_directs/screens/edit_screens/add/add_item_page.dart';
import 'package:shop_directs/cubit/counter/counter_cubit.dart';
import '../../utils/size_config.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/user.dart';
import 'package:shop_directs/screens/authentication_screens/login_screen.dart';
import 'package:shop_directs/screens/main/components/filter.dart';
import 'package:shop_directs/screens/main/components/items_stream.dart';
import 'package:shop_directs/screens/main/my_items_screen.dart';
import 'package:shop_directs/utils/Constants.dart';
import 'package:shop_directs/utils/enums.dart';
import 'components/main_drawer.dart';

class ItemsScreen extends StatefulWidget  {
  static const String id = '/items_screen';

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> with
    SingleTickerProviderStateMixin{

  bool showSpinner = false;
  ScrollController _scrollController;
  AnimationController _hidFabAnimationController;
  double _scrollPosition;


  _scrollListener() {
  }

  setScrollDown(){
   /* if (_scrollController.hasClients)
    _scrollController.animateTo(
    _scrollController.position.maxScrollExtent,
    duration: Duration(milliseconds: 600),
    curve: Curves.linear);*/
    _hidFabAnimationController.reverse();
  }
  setScrollUp(){
   /* if (_scrollController.hasClients)
    _scrollController.animateTo(
     0,
    duration: Duration(milliseconds: 600),
    curve: Curves.linear);*/

    _hidFabAnimationController.forward();

  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hidFabAnimationController.dispose();
    super.dispose();
  }


  @override
  void initState(){

    _scrollController = ScrollController();
    _hidFabAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      value: 1
    );
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),

        body: Stack(
          children: [
            Image.asset(
              "assets/images/main_background.jpg",
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenHeight,
              fit: BoxFit.cover,
            ),
            BlocBuilder<ScrollCubit, ScrollState>(
              builder: (context, state){

                if(state.scroll == ScrollType.ScrollDown){
                  print('reiiiiight');
                  setScrollDown();
                }else if(state.scroll == ScrollType.ScrollUp){
                  setScrollUp();
                }
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverFillRemaining(
                      child: BlocBuilder<InternetCubit,InternetState>(

                        builder: (internetCubitBuilderContext, state) {
                          if(state is InternetConnected) {
                            return Column(
                            children: [
                            //  Filter(),
                              Expanded(
                                child: BlocBuilder<CounterCubit, CounterState>(
                                  builder: (context, state) => ItemsStream(
                                    stream : FirebaseFirestoreStream()
                                        .getItemsStream(
                                        filterSortContent: state.filterSortContent,
                                        selectedCategories: state.selectedCategories,
                                    ),
                                    des: DetailPage.id,

                                  ),

                                ),
                              )
                            ],
                          );
                          } else if(state is InternetDisconnected) {
                          return Container(
                            padding: EdgeInsets.all(getProportionateSize(30)),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.exclamation,
                                  color: Colors.red,
                                ),
                                Text('Connection Failed')
                              ],
                            ),
                          );
                        }
                          else
                            return CircularProgressIndicator();
                      }
                      ),
                    )
                  ],

                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: MainDrawer(),
        ),


      floatingActionButton: FadeTransition(
        opacity: _hidFabAnimationController,
        child: ScaleTransition(
          scale: _hidFabAnimationController,
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              // BlocProvider.of<UserCubit>(context).emitUserLoading();
              final internetState =context.watch<InternetCubit>().state;
              return Container(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  FloatingActionButton.extended(
                  backgroundColor: Color(0xaf3ff335),
                    icon: Icon(Icons.add),
                    onPressed: ()
                    {
                      if(internetState is InternetConnected) {
                        if(state is UserLogged) {
                          Navigator.pushNamed(context, AddItemPage.id);
                        } else {
                          if(state is UserNull)
                            Navigator.pushNamed(context, LoginScreen.id);
                        }
                      }
                      else if(internetState is InternetDisconnected){
                        final snackBar = SnackBar(content:
                        Text('No internet connection'),
                        backgroundColor: Colors.red,
                        duration: Duration(milliseconds: 500),);
                        Scaffold.of(context).showSnackBar(snackBar);
                      }

                  },
                  label: Text('Add an item'))



                  ],
                ),
              );
            }
          ),
        ),
      )
      );
  }

  AppBar buildAppBar() {
    return AppBar(

      backgroundColor: Colors.blueGrey,
      elevation: 0,

      actions: <Widget>[
        IconButton(
          icon: Icon(FontAwesomeIcons.search),
          onPressed: () async{
            print(MediaQuery.of(context).size.height);
            print(MediaQuery.of(context).size.width);
          },
        ),
        IconButton(
          icon: Icon(FontAwesomeIcons.slidersH),
          onPressed: showBottomSheet,
        ),
        SizedBox(width: kDefaultPadding / 2)
      ],
    );
  }

  void showBottomSheet(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
            child:Container(
              height: MediaQuery.of(context).size.height*0.9,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Filter(),
            )
        )
    );
  }

}






