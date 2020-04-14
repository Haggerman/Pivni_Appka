import 'package:MyFirtApp_Honzin/models/person.dart';
import 'package:MyFirtApp_Honzin/screens/map/place_tile.dart';
import 'package:MyFirtApp_Honzin/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MyFirtApp_Honzin/models/user.dart';

class PlacesList extends StatefulWidget {
  final UserData user;
  PlacesList({this.user});
  @override
  _PlacesListState createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {

  @override
    Widget build(BuildContext context) {
    final people = Provider.of<List<Person>>(context) ?? [];
    Person person;
    final user = Provider.of<User>(context);
    for (var i = 0; i < people.length; i++) {
      if (people[i].uid == user.uid) {
        person = people[i];
      }
    }

    if (person != null) {
      return ListView.builder(
          itemCount: person.userPlaces.length,
          itemBuilder: (context, index) {
            return PlaceTile(place: person.userPlaces.reversed.toList()[index], userId: user.uid,);
          });
    }
    else{
      return Loading();
    }
  }
}
