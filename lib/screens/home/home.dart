import 'package:MyFirtApp_Honzin/models/person.dart';
import 'package:MyFirtApp_Honzin/screens/map/all_places.dart';
import 'package:MyFirtApp_Honzin/screens/profile/profile.dart';
import 'package:MyFirtApp_Honzin/services/auth.dart';
import 'package:MyFirtApp_Honzin/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MyFirtApp_Honzin/services/database.dart';
import 'package:provider/provider.dart';
import 'package:MyFirtApp_Honzin/screens/home/people_list.dart';
import 'package:MyFirtApp_Honzin/screens/home/settings_form.dart';


class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

  void _closeModal(void value) {
    }
    void _showSettingsPanel() {

        Future<void> future = showModalBottomSheet<void>(
            context: context, builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: SettingsForm(),
          );
        });
        future.then((void value) => _closeModal(value));
    }

    return StreamProvider<List<Person>>.value(
      value: DataBaseService().people,
      child: Scaffold(
        backgroundColor: Colors.amber[50],
        appBar: AppBar(
          title: new RichText(
            text: new TextSpan(
              style: new TextStyle(
                fontSize: 22.0,
                color: Colors.white,
              ),
              children: <TextSpan>[
                new TextSpan(text: 'Pivní', style: new TextStyle(fontWeight: FontWeight.bold, shadows: textShadow)),
                new TextSpan(text: ' appka ',style:  new TextStyle( shadows: textShadow)),
              ],
            ),
          ),
          backgroundColor: Colors.amber[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton(
              child: Icon(Icons.map, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllPlaces()),
                );
              },
            ),
            FlatButton(
        child: Icon(Icons.portrait, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profile()),
          );
        },
      ),
            FlatButton(
                child: Icon(Icons.highlight_off, color: Colors.white),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: SizedBox(width:400, child: PeopleList()),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showSettingsPanel(),
          tooltip: 'Status change',
          child: const Icon(Icons.local_bar),
          backgroundColor: Colors.amber[400],
        ),
      ),
    );
  }
}
