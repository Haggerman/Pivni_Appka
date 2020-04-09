import 'package:MyFirtApp_Honzin/models/person.dart';
import 'package:MyFirtApp_Honzin/services/database.dart';
import 'package:MyFirtApp_Honzin/shared/constants.dart';
import 'package:MyFirtApp_Honzin/shared/loading.dart';
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
  LatLng position;
  Person person;
  String userUid;
  final Map<String, Marker> _markers = {};
  String text;
  bool loading = true;

  void initState() {
    person = widget.person;
    userUid= widget.userUid;
    position = LatLng(person.latitude, person.longitude);
    super.initState();
    if(person.uid == userUid) {
      Geolocator().getCurrentPosition().then((currentLoc) {
        setState(() {
          loading = false;
          text = 'Tady se nacházíš';
          position = LatLng(currentLoc.latitude, currentLoc.longitude);
          markerSet();
        });
      });
    }
    else{
      setState(() {
        loading = false;
        text = 'Tady se nachází ${person.name}';
        markerSet();
      });
    }
  }

  void markerSet(){
    _markers.clear();
    final marker = Marker(
      markerId: MarkerId("curr_loc"),
      position: position,
      infoWindow: InfoWindow(title: text),
    );
    _markers["Current Location"] = marker;
  }

  void onMapCreated(controller){
    setState(() {
      mapController = controller;
    });
}

  showAlertDialog(BuildContext context) {
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
                ),
              ],
            ),
       floatingActionButton: person.uid == userUid? FloatingActionButton(
         onPressed: () async {
           await DataBaseService(uid: person.uid).updateLocation(
             position.latitude ?? 50.5654,
             position.longitude ?? 15.9091,
           );
           showAlertDialog(context);
         },
         tooltip: 'Status change',
         child: const Icon(Icons.send ),
         backgroundColor: Colors.amber[400],
       ): null,
        );
  }
}
