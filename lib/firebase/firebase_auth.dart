
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:shop_directs/firebase/firestore/firestore_read.dart';
import 'package:shop_directs/models/user.dart' as u;

class FirebaseAuthClass{
  static final FirebaseAuth _auth= FirebaseAuth.instance;
  static u.User _user;



  static u.User get currentUser => _user;


  Future<UserCredential> createNewUser(String email, String password) async{
    try{
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return newUser;
    }catch(e){
      print(e);
      return null;
    }
  }

  Future<UserCredential> loginUser(String email,
      String password,) async{
    try{
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    }catch(e){
      print(e);
      return null;
    }
  }

  Future<void> signOut() async{
    return Future.wait([_auth.signOut()]);
  }

  Future<bool> isSignedIn() async{
    return
      getCurrentUserUid() !=null;
  }

  Stream<User> getUser() async* {

    if(_auth.currentUser !=null) {
      print(_auth.currentUser.email);
      await _setLoggedInUser();
      yield _auth.currentUser;
    } else yield null;
  }

  Future<void> _setLoggedInUser() async{
    _user =await
    FirebaseFirestoreRead().loadUserData(userUid: getCurrentUserUid());

  }

  Future<void> deleteUser() async{
    await _auth.currentUser.delete();
  }



  static String getCurrentUserUid(){
    if(_auth.currentUser != null)
      return _auth.currentUser.uid;
    else
      return null;
  }
}