import 'package:MyFirtApp_Honzin/services/database.dart';
import 'package:MyFirtApp_Honzin/shared/constants.dart';
import 'package:MyFirtApp_Honzin/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:MyFirtApp_Honzin/models/user.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool loading = false;
  String _currentName;
  String error = '';
  final _formKey = GlobalKey<FormState>();
  File imageFile;

  _openGallery(BuildContext context, String uid) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);
    this.setState(() {
      imageFile = picture;
    });

    Navigator.of(context).pop();
  }
  _openCamera(BuildContext context, String uid) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }


  Future<void> _showChoiceDialog(BuildContext context, String uid){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Vyber zdroj"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text('Galerie'),
                onTap: () {
                  _openGallery(context, uid);
                },
              ),
              Padding(padding: EdgeInsets.all(8)),
              GestureDetector(
                child: Text('Fotoaparát'),
                onTap: () {
                  _openCamera(context, uid);
                },
              )
            ],
          ),
        ),
      );
    });
  }

  Future<bool> _onBackPressed() async{
    return await ( showDialog(context: context,
    builder: (context)=>AlertDialog(
      title: Text("Opravdu nechceš změnit obrázek?"),
      actions: <Widget>[
        FlatButton(
          child: Text('Vlastně chci'),
          onPressed: ()=>Navigator.pop(context, false),
        ),
        FlatButton(
          child: Text('Nechci'),
          onPressed: ()=>Navigator.pop(context, true),
        )
      ],
    ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DataBaseService(uid: user.uid).userData,
        builder: (context,snapshot) {
          if(snapshot.hasData){
            UserData userData = snapshot.data;
            return loading != true? WillPopScope(
              onWillPop: imageFile != null? _onBackPressed: null,
            child: Scaffold(
                backgroundColor: Colors.amber[100],
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
                        new TextSpan(text: userData.name , style: new TextStyle(fontWeight: FontWeight.bold,shadows: textShadow)),
                        new TextSpan(text: ' profil ',style:  new TextStyle( shadows: textShadow)),
                      ],
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(350),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF000000).withAlpha(60),
                                    blurRadius: 8.0,
                                    spreadRadius: -8.0,
                                    offset: Offset(
                                      0.0,
                                      23.0,
                                    ),
                                  ),
                                ]),
                            child: imageFile == null? CircleAvatar(
                              radius: 75,
                              backgroundImage: (userData.picUrl != '0')?NetworkImage("https://firebasestorage.googleapis.com/v0/b/myfirstporject-e7175.appspot.com/o/${userData.picUrl}?alt=media"):
                              NetworkImage('https://firebasestorage.googleapis.com/v0/b/myfirstporject-e7175.appspot.com/o/wojak.png?alt=media'),
                            ): CircleAvatar(
                              radius: 75,
                              backgroundImage: new FileImage(imageFile),
                            )
                          ),

                          SizedBox(height: 20.0),
                          TextFormField(
                            initialValue: userData.name,
                            decoration: textInputDecoration.copyWith(hintText: 'Jméno'),
                            validator: (val) => val.length < 4 ? 'Jméno musí být alespoň 4 znaky dlouhé' : null,
                            onChanged: (val) => setState(() => _currentName = val),
                          ),

                          SizedBox(height: 20.0),
                          RaisedButton(
                            color: Colors.pink[400],
                            child: Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              DataBaseService database = DataBaseService(uid: user.uid);
                              setState(() {
                                loading = true;
                              });
                              if(_formKey.currentState.validate()) {
                                await database.updateUserName(
                                  _currentName ?? userData.name,
                                );
                              }
                              if(imageFile != null){
                                String stamp = new DateTime.now().millisecondsSinceEpoch.toString();
                                if(userData.picUrl != '0'){
                                  await database.deletePic(userData.picUrl);
                                }

                                await database.uploadPic(context, user.uid + stamp, imageFile);
                                await database.updateProfilePic(
                                    user.uid + stamp
                                );
                              }
                              setState(() {
                                loading = false;
                              });
                              Navigator.pop(context);
                            },

                          ),
                          SizedBox(height: 12.0),
                          Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 14.0)
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              floatingActionButton: FloatingActionButton(
                onPressed: () =>  _showChoiceDialog(context, userData.uid),
                tooltip: 'Status change',
                child: const Icon(Icons.photo_camera),
                backgroundColor: Colors.amber[400],
              ),
            ),
            ):Loading();
          }
          else{
            return Loading();
          }
        }
    );
  }
}


