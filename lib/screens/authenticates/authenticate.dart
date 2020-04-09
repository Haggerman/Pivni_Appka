import 'package:MyFirtApp_Honzin/screens/authenticates/register.dart';
import 'package:MyFirtApp_Honzin/screens/authenticates/sign_in.dart';
import 'package:flutter/material.dart';


class Authentiacete extends StatefulWidget {
  @override
  _AuthentiaceteState createState() => _AuthentiaceteState();
}

class _AuthentiaceteState extends State<Authentiacete> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
   if(showSignIn){
     return SignIn(toggleView : toggleView);
   }
   else{
     return Register(toggleView : toggleView);
   }
  }
}
