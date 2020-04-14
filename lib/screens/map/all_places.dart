import 'package:MyFirtApp_Honzin/models/person.dart';
import 'package:MyFirtApp_Honzin/screens/map/places_list.dart';
import 'package:MyFirtApp_Honzin/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:MyFirtApp_Honzin/services/database.dart';
import 'package:provider/provider.dart';

class AllPlaces extends StatefulWidget {

  @override
  _AllPlacesState createState() => _AllPlacesState();
}

class _AllPlacesState extends State<AllPlaces> {

  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {

    return StreamProvider<List<Person>>.value(
        value: DataBaseService().people,
            child:  Scaffold(
              backgroundColor: Colors.amber[50],
              appBar: AppBar(
                backgroundColor: Colors.amber[400],
                elevation: 0.0,
                title: new RichText(
                  text: new TextSpan(
                    style: new TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      new TextSpan(text: 'Tvá' , style: new TextStyle(fontWeight: FontWeight.bold,shadows: textShadow)),
                      new TextSpan(text: ' místa',style:  new TextStyle( shadows: textShadow)),
                    ],
                  ),
                ),
              ),
                body: SizedBox(width: 400, child: PlacesList()),

    ));
  }
}