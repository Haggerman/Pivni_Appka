import 'package:MyFirtApp_Honzin/models/person.dart';
import 'package:MyFirtApp_Honzin/models/place.dart';
import 'package:MyFirtApp_Honzin/services/database.dart';
import 'package:MyFirtApp_Honzin/shared/constants.dart';
import 'package:MyFirtApp_Honzin/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  final Person person;
  final String userUid;
  Maps({this.person, this.userUid});

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapController mapController;
  final _formKey = GlobalKey<FormState>();
  LatLng position;
  Person person;
  String userUid;
  Map<String, Marker> _markers = {};
  ArgumentCallback<LatLng> onTap;
  String text;
  bool newMarker = false;
  bool loading = true;
  String error = '';

  void initState() {
    person = widget.person;
    userUid= widget.userUid;
    position = LatLng(person.latitude.toDouble(), person.longitude.toDouble());
    super.initState();
    if(person.uid == userUid) {
      Geolocator().getCurrentPosition().then((currentLoc) {
        setState(() {
          loading = false;
          text = 'Tady se nacházíš';
          position = LatLng(currentLoc.latitude.toDouble(), currentLoc.longitude.toDouble());
          _markerSet();
        });
      });
    }
    else{
      setState(() {
        loading = false;
        text = 'Tady se nachází ${person.name}';
        _markerSet();
      });
    }
  }

  _markerSet(){
    _markers.clear();
    _markers["Current Location"] = Marker(
      markerId: MarkerId("curr_loc"),
      position: position,
      infoWindow: InfoWindow(title: text),
      icon:
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
    if(person.place != 'Nikde'){
      print(person.naMiste());

      _markers["Destination"] = Marker(
        markerId: MarkerId("destination"),
        position: LatLng(person.getPlaceDetails().latitude.toDouble(), person.getPlaceDetails().longitude.toDouble()),
        infoWindow: InfoWindow(title: person.place),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
    }
  }

  _handleTap(LatLng point) {
      if(newMarker == false) {
        newMarker = true;
        setState(() {
          _markers['New'] = Marker(
            markerId: MarkerId(point.toString()),
            position: point,
            infoWindow: InfoWindow(
              title: 'Nová poloha',
            ),
            icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          );
        });
      }
      else if(newMarker == true){
        newMarker = false;
        setState(() {
          _markers.remove('New');
        });
      }
  }

   onMapCreated(controller){
    setState(() {
      mapController = controller;
    });
}

  _showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Poloha úspěšně nasdílena"),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Future<void>_saveDialog(BuildContext context, String uid){
    return showDialog(context: context, builder: (context){
       String _currentName;
      return AlertDialog(
       backgroundColor: Colors.amber[200],
        content: Container(
          height: 160,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Jméno místa'),
                  validator: (val) => val.length < 4 ? 'Jméno musí být delší než 4 znaky' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),

                SizedBox(height: 20.0),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Uložit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    DataBaseService database = DataBaseService(uid: uid);
                    if(_formKey.currentState.validate()) {
                     Place checkPlace = person.placeByName(_currentName);
                     if(checkPlace != null){
                     await database.deleteLocation(checkPlace.name, checkPlace.latitude, checkPlace.longitude);
                     }

                      await database.addNewLocation(
                        _currentName,
                        _markers['New'].position.latitude.toDouble(),
                        _markers['New'].position.longitude.toDouble()
                      );
                      Navigator.pop(context);
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
      );
    });

  }

  @override
  Widget build(BuildContext context) {
     return loading ? Loading() : Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: (person.picUrl != '0')?NetworkImage("https://firebasestorage.googleapis.com/v0/b/myfirstporject-e7175.appspot.com/o/${person.picUrl}?alt=media"):
                  NetworkImage('https://firebasestorage.googleapis.com/v0/b/myfirstporject-e7175.appspot.com/o/wojak.png?alt=media'),
                ),
              ),
            ),
          ],
          title: person.uid != userUid? new RichText(
            text: new TextSpan(
              style: new TextStyle(
                fontSize: 22.0,
                color: Colors.white,
              ),
              children: <TextSpan>[
                new TextSpan(text: person.name , style: new TextStyle(fontWeight: FontWeight.bold,shadows: textShadow)),
                new TextSpan(text: ' je tady ',style:  new TextStyle( shadows: textShadow)),
              ],
            ),
          ): new Text('Seš tady', style: new TextStyle(color: Colors.white, shadows: textShadow),),
          backgroundColor: Colors.amber[400],

        ),
        body:
            Stack(
              children: <Widget>[
                  GoogleMap(
                    markers: _markers.values.toSet(),
                    onMapCreated: onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: position,
                      zoom: 10,
                    ),
                    onTap: person.uid == userUid?  _handleTap: null,
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child:  person.uid == userUid? Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        newMarker? FloatingActionButton(
                          heroTag: 'btn2',
                          onPressed: () {_saveDialog(context, person.uid);},
                          tooltip: 'Status change',
                          child: const Icon(Icons.save ),
                          backgroundColor: Colors.amber[400],
                        ):Container(),
                        SizedBox(height: 16.0),
                         FloatingActionButton(
                           heroTag: 'btn1',
                          onPressed: () async {
                            await DataBaseService(uid: person.uid).updateLocation(
                              position.latitude ?? 50.5654,
                              position.longitude ?? 15.9091,
                            );
                            _showAlertDialog(context);
                          },
                          tooltip: 'Status change',
                          child: const Icon(Icons.send ),
                          backgroundColor: Colors.amber[400],
                        ),
                      ],
                    )
                  ): null,
                ),

              ],
            ),
        );
  }

}
