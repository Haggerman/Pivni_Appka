import 'package:MyFirtApp_Honzin/services/auth.dart';
import 'package:MyFirtApp_Honzin/shared/constants.dart';
import 'package:MyFirtApp_Honzin/shared/loading.dart';
import 'package:flutter/material.dart';


class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  bool loading = false;
  String email = '';
  String password = '';
  String nick = '';
  String error = '';
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
            backgroundColor: Colors.amber[400],
            elevation: 0.0,
            title: Text('Zaregistruj se do Pivní appky'),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () {widget.toggleView();},
            label: Text('Login', style: TextStyle(color: Colors.white)),
                icon: Icon(Icons.person, color: Colors.white,),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Jméno'),
                    validator: (val) => val.length < 4 ? 'Jméno musí být alespoň 4 znaky dlouhé' : null,
                    onChanged: (val){
                      setState(() => nick = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? 'Zadej email' : null,
                    onChanged: (val){
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Heslo'),
                    obscureText: true,
                    validator: (val) => val.length < 6 ? 'Heslo musí být alespoň 6 znaků dlouhé' : null,
                    onChanged: (val){
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                        'Registrovat',
                        style: TextStyle(color: Colors.white)
                    ),
                    onPressed: () async{
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.registerWithEmailAndPasword(email, password, nick);
                      if(result == null){
                        setState((){
                          error = 'Uživatel se zadanými údaji neexistuje';
                          loading = false;
                        });
                      }
                    }
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
        )
    );
  }
}
