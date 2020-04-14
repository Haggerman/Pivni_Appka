import 'package:MyFirtApp_Honzin/models/user.dart';
import 'package:MyFirtApp_Honzin/services/database.dart';
import 'package:MyFirtApp_Honzin/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:MyFirtApp_Honzin/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';


class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> places = ['Doma','Trut','Irská','Pivovarská','Pasáž', 'Sangrie v parku', 'Jinde?!'];
  String _currentPlace;
  int _currentThirst;
  ShakeDetector detector;



  @override
  Widget build(BuildContext context) {
 detector = ShakeDetector.autoStart(onPhoneShake:(){
   detector.stopListening();
   if(mounted){
        setState(() {
          _currentThirst = 800;
        });}
    } );

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DataBaseService(uid: user.uid).userData,
      builder: (context,snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          places = userData.getPlaces();
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                    'Kde se kalí',
                    style: TextStyle(fontSize: 18.0)
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentPlace ?? userData.place,
                  items: places.map((place) {
                    return DropdownMenuItem(
                      value: place,
                      child: Text('$place'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _currentPlace = val),
                ),
                SizedBox(height: 20),
                Text('Žízeň level', style: TextStyle(fontSize: 18.0)),
                Slider(
                  value: (_currentThirst ?? userData.thirst).toDouble(),
                  activeColor: Colors.amber[_currentThirst ?? userData.thirst],
                  inactiveColor: Colors.amber[_currentThirst ?? userData.thirst],
                  min: 100,
                  max: 800,
                  divisions: 7,
                  onChanged: (val) =>
                      setState(() => _currentThirst = val.round()),
                ),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){}
                    await DataBaseService(uid: user.uid).updateUserStatus(
                        _currentPlace ?? userData.place,
                        _currentThirst ?? userData.thirst
                    );
                    detector.stopListening();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        }
        else{
          return Loading();
        }
      }
    );
  }
}
