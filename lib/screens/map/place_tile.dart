import 'package:MyFirtApp_Honzin/models/place.dart';
import 'package:MyFirtApp_Honzin/services/database.dart';
import 'package:MyFirtApp_Honzin/shared/constants.dart';
import 'package:flutter/material.dart';

class PlaceTile extends StatelessWidget {
  final Place place;
  final String userId;
  PlaceTile({this.place, this.userId});
  Future<bool> _onDelete(BuildContext context, String userUid) async{
    return await ( showDialog(context: context,
      builder: (context)=>AlertDialog(
        title: Text("Opravdu chceš smazat toto místo?"),
        actions: <Widget>[
          FlatButton(
            child: Text('Ano'),
              onPressed: () async {
                await DataBaseService(uid: userUid).deleteLocation(place.name, place.latitude, place.longitude);
                Navigator.pop(context);
              },
          ),
          FlatButton(
            child: Text('Ne'),
            onPressed: ()=>Navigator.pop(context),
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return place.name != 'Nikde' ? Padding(
      padding:  EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(350),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000).withAlpha(60),
                blurRadius: 8.0,
                spreadRadius:  -17.0,
                offset: Offset(
                  0.0,
                  23.0,
                ),
              ),
            ]),

        child: Card(
          color: Colors.amber[100],
          shape:  StadiumBorder(
            side: BorderSide(
              color: Colors.amber[800],
              width:  2,
            ),
          ),
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child:ListTile(
            title: Text(place.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,  shadows:  textShadow),),
                trailing:  IconButton(icon: Icon(Icons.delete_forever), onPressed: () {
                  _onDelete(context, userId);
                }),
          ),
        ),
        ),
      ) : Container();
  }
}
