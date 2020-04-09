import 'package:MyFirtApp_Honzin/models/user.dart';
import 'package:MyFirtApp_Honzin/screens/authenticates/authenticate.dart';
import 'package:MyFirtApp_Honzin/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
   if (user == null){
     return Authentiacete();
   }
   else{
     return Home();
   }

  }
}
