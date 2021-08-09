import 'package:flutter/foundation.dart';

import 'Item.dart';

class ItemUserFavourite {
  ItemUserFavourite({@required this.item, @required this.isFavourite});

  final Item item;
  final bool isFavourite;
}
