import 'package:MyFirtApp_Honzin/models/person.dart';
import 'package:MyFirtApp_Honzin/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MyFirtApp_Honzin/screens/home/person_tile.dart';

class PeopleList extends StatefulWidget {
  @override
  _PeopleListState createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  @override
  Widget build(BuildContext context) {
    final people = Provider.of<List<Person>>(context) ?? [];
    final user = Provider.of<User>(context);
    for(var i=0;i<people.length;i++){
      if(people[i].uid == user.uid && i != 0){
        Person person = people[0];
        people[0]= people[i];
        people[i]=person;
      }
    }
    return ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index){
          return PersonTile(person: people[index]);
        });
  }
}
