
import 'dart:ui';

import 'package:shop_directs/models/user.dart';

class Item {
  final String title, userId, description, category, date,id;
  final double price;
  final DateTime dateTime;
  final List<dynamic> images;

  Item({
    this.id,
    this.title,
    this.date,
    this.dateTime,
    this.description,
    this.userId,
    this.category,
    this.images,
    this.price,
});

  factory Item.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return Item(
        id: documentId, title: data['title'], description: data['description'],
        date: data['date'], dateTime: data['dateTime'], userId: data['userId'],
        category: data['category'], images: data['images'], price: data['price']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date' :date,
      'dateTime': dateTime,
      'userId': userId,
      'category': category,
      'images' : images,
      'price': price
    };
  }

  @override
  int get hashCode => hashValues(id, title, description);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Item otherItem = other;
    return id == otherItem.id &&
        title == otherItem.title &&
        description == otherItem.description &&
        date == otherItem.date &&
        dateTime == otherItem.dateTime &&
        userId == otherItem.userId &&
        category == otherItem.category &&
        images == otherItem.images &&
        price == otherItem.price
        ;
  }

  @override
  String toString() => 'id: $id, title: $title, description: $description'
      'date: $date, dateTime: $dateTime, userId: $userId, category: $category,'
      'images: $images, price: $price';

}

