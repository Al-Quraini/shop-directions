
part of 'user_cubit.dart';


@immutable
abstract class UserState{}

class UserLoading extends UserState {}


class UserLogged extends UserState{
  final User user;

  UserLogged({@required this.user});


}

class UserNull extends UserState{}