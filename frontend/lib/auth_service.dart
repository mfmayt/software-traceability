import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthService{
  handleAuth(){
    return StreamBuilder(

      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot){
        if(snapshot.hasData) {
          return HomePage();
        } else{
          return LoginPage();
        }
      }
    );
  }
  //Sign Out
  signOut(){
    FirebaseAuth.instance.signOut();
  }
  //Sign In
  singIn(email,password){
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((user) {
      print('Signed in');
    }).catchError((e){
      print(e);
    });
  }
}