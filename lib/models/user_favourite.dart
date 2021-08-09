import 'dart:ui';

import 'package:flutter/foundation.dart';

class UserFavourite {
  UserFavourite({@required this.itemId, @required this.isFavourite});
  final String itemId;
  final bool isFavourite;

  factory UserFavourite.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return UserFavourite(itemId: documentId, isFavourite: data['isFavourite']);
  }

  Map<String, dynamic> toMap() {
    return {
      'isFavourite': isFavourite,
    };
  }

  @override
  int get hashCode => hashValues(itemId, isFavourite);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final UserFavourite otherFavourite = other;
    return itemId == otherFavourite.itemId &&
        isFavourite == otherFavourite.isFavourite;
  }

  @override
  String toString() => 'itemId: $itemId, isFavourite: $isFavourite';
}
