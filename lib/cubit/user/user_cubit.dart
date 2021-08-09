import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth_u;
import 'package:flutter/material.dart';
import 'package:shop_directs/firebase/firebase_auth.dart';
import 'package:shop_directs/models/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState>{
  final Stream<auth_u.User> userStream;
  StreamSubscription userLoginSubscription;

  UserCubit({this.userStream}) : super(UserNull()) {
    print('emotting');
    monitorLoggedInUser();
  }

  StreamSubscription<auth_u.User> monitorLoggedInUser() {
    return userLoginSubscription =
        FirebaseAuthClass().getUser().listen((user) {
        if(user != null) {
          print('emit emit emit emmmmmmmmmmmmmmmit this is emit ${
              FirebaseAuthClass.currentUser.email
          }');

          emitUserLogged(FirebaseAuthClass.currentUser);

        }
        else if (user == null) {
          print('kaleeeeeeeeeeeeeeee');
          emitUserNull();
        }
      });
  }


  void emitUserLogged(User user) =>
      emit(UserLogged(user: user));

  void emitUserNull() =>
      emit(UserNull());

  void emitUserLoading() =>
      emit(UserLoading());

  @override
  Future<void> close() {
    userLoginSubscription.cancel();
    return super.close();
  }

}