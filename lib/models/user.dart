import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:ui';



@JsonSerializable()
class User extends Equatable{

final String name, email, imageUrl, phoneNumber,location,uid;

  User( {
    this.name,
    this.email,
    this.imageUrl,
    this.phoneNumber,
    this.location,
    this.uid,
  });

@override
  List<Object> get props =>[this.name, this.email,
  this.phoneNumber, this.location, this.phoneNumber];



factory User.fromMap(Map<dynamic, dynamic> data, String documentId) {
  if (data == null) {
    return null;
  }
  return User(
      uid: documentId, name: data['name'], email: data['email'],
      imageUrl: data['imageUrl'], phoneNumber: data['phoneNumber'],
      location: data['location']
  );
}

Map<String, dynamic> toMap() {
  return {
    'name': name,
    'email': email,
    'imageUrl' :imageUrl,
    'phoneNumber': phoneNumber,
    'location': location,

  };
}

@override
int get hashCode => hashValues(uid, name, email);

@override
bool operator ==(dynamic other) {
  if (identical(this, other)) return true;
  if (runtimeType != other.runtimeType) return false;
  final User otherItem = other;
  return uid == otherItem.uid &&
      name == otherItem.name &&
      email == otherItem.email &&
      imageUrl == otherItem.imageUrl &&
      phoneNumber == otherItem.phoneNumber &&
      location == otherItem.location
  ;
}

@override
String toString() => 'uid: $uid, name: $name, email: $email'
    'imageUrl: $imageUrl, phoneNumber: $phoneNumber, location: $location ';





}
