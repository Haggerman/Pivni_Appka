import 'package:MyFirtApp_Honzin/models/user.dart';
import 'package:MyFirtApp_Honzin/screens/map/map.dart';
import 'package:MyFirtApp_Honzin/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:MyFirtApp_Honzin/models/person.dart';
import 'package:provider/provider.dart';

class PersonTile extends StatelessWidget {
  final Person person;
  PersonTile({this.person});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Padding(
      padding: person.uid == user.uid?  EdgeInsets.fromLTRB(0, 8, 0, 30): EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(

        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(350),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000).withAlpha(60),
                blurRadius: 8.0,
                spreadRadius: person.uid == user.uid? -12:  -17.0,
                offset: Offset(
                  0.0,
                  23.0,
                ),
              ),
            ]),

        child: Card(
          shape:  StadiumBorder(
            side: BorderSide(
              color: person.uid == user.uid? Colors.amber[800]: Colors.white,
              width: person.uid == user.uid? 4: 0,
            ),
          ),

          color: Colors.amber[person.thirst],
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child:ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Maps(person:person, userUid: user.uid)),
              );
            },

            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: (person.picUrl != '0')?NetworkImage("https://firebasestorage.googleapis.com/v0/b/myfirstporject-e7175.appspot.com/o/${person.picUrl}?alt=media"):
              NetworkImage('https://firebasestorage.googleapis.com/v0/b/myfirstporject-e7175.appspot.com/o/wojak.png?alt=media'),
            ),
            title: Text(person.name, style: TextStyle(color: Colors.white,fontSize: 22, fontWeight: FontWeight.bold,  shadows:  textShadow),),
            subtitle: Text(' ${person.place} ', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold,shadows: textShadow )),
            trailing: person.place != 'Nikde'? person.naMiste()?

                  Icon(Icons.check_circle_outline, color: Colors.green):
                  Icon(Icons.do_not_disturb_alt, color: Colors.red)
            :null
          ),
        ),
      ),
    );
  }
}
