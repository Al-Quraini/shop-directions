

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shop_directs/cubit/counter/counter_cubit.dart';
import 'package:shop_directs/firebase/firestore/firestore_streams.dart';
import 'package:shop_directs/models/Item.dart';
import 'package:shop_directs/models/item_user_favourite.dart';
import 'package:shop_directs/models/user_favourite.dart';

class ItemListViewModel{

  Stream<List<ItemUserFavourite>> itemUserFavouritesStream(){
    return Rx.combineLatest2(
        FirebaseFirestoreStream().getItemsStream(),
        FirebaseFirestoreStream().likedItemsStream(),
            (movies,userFavourites) {
          return movies.map((movie) {
            final userFavourite = userFavourites?.firstWhere(
                    (userFavourite) => userFavourite.movieId == movie.id,
                orElse: () => null);
            return ItemUserFavourite(
              item: movie,
              isFavourite: userFavourite?.isFavourite ?? false,
            );
          }).toList();
        });
  }
}