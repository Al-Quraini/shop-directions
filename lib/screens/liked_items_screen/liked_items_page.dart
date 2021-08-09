import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_directs/cubit/counter/counter_cubit.dart';
import 'package:shop_directs/cubit/internet_cubit/internet_cubit.dart';
import 'package:shop_directs/screens/detail/detail_page.dart';
import 'package:shop_directs/screens/liked_items_screen/liked_items_stream.dart';
import 'package:shop_directs/screens/main/components/items_stream.dart';
import 'package:shop_directs/utils/size_config.dart';

class LikedItemsPage extends StatelessWidget {
  static const String id = '/liked_items_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Items'),
      ),
      body: Container(
        child: BlocBuilder<InternetCubit,InternetState>(

            builder: (internetCubitBuilderContext, state) {
              if(state is InternetConnected) {
                return Column(
                  children: [
                    //  Filter(),
                    Expanded(
                      child: BlocBuilder<CounterCubit, CounterState>(
                        builder: (context, state) => LikedItemsStream()
                    )
                    )],
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
              else return null;
            }
        ),
      ),
    );
  }
}
