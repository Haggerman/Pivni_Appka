import 'package:MyFirtApp_Honzin/models/place.dart';
import 'package:MyFirtApp_Honzin/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';

class Person {

  final String name;
  String place;
  final int thirst;
  final String picUrl;
  final double latitude;
  final double longitude;
  final String uid;
  final List<Place> userPlaces;
  final Timestamp update;

  Person({this.name, this.place, this.thirst, this.picUrl, this.latitude, this.longitude, this.uid, this.userPlaces, this.update}){
   Place myPlace = placeByName(place);
   if(myPlace == null){
     this.place = 'Nikde';
     DataBaseService(uid: uid).updateUserStatus('Nikde', thirst);
   }
  }

  Place getPlaceDetails(){
    Place placeDetail ;
    for (var i = 0; i < userPlaces.length; i++) {
      if(userPlaces[i].name == place){
        placeDetail = userPlaces[i];
      }
    }
    return  placeDetail;
  }

  bool naMiste(){
    if(place == 'Nikde')
      return false;
    Distance distance = new Distance();
     double meters = distance(
        new LatLng(latitude,longitude),
        new LatLng(getPlaceDetails().latitude,getPlaceDetails().longitude)
    );
     if(meters < 30)
       return true;
     return false;
  }

  Place placeByName(String name){
    Place placeDetail ;
    for (var i = 0; i < userPlaces.length; i++) {
      if(userPlaces[i].name == name){
        placeDetail = userPlaces[i];
      }
    }
    return  placeDetail;
  }

}