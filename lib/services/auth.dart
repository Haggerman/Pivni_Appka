import 'package:MyFirtApp_Honzin/models/user.dart';
import 'package:MyFirtApp_Honzin/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }
  
  // auth changed user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
          .map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
     try {
       AuthResult result = await _auth.signInAnonymously();
       User user = _userFromFirebaseUser(result.user);
       return user;
     }
     catch(e){
      print(e.toString());
      return null;
     }
  }

  //sign in with email and password
  Future signInWithEmailAndPasword(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPasword(String email, String password, String nick) async{
    try{
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    DataBaseService dataBaseService = new DataBaseService(uid: user.uid);

    await dataBaseService.updateUserData('Nikde', nick, 100 );

    return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async{
    try{
  return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }

  }
}