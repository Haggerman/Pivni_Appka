import 'package:MyFirtApp_Honzin/models/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  final String uid;
  User({this.uid});

}

class UserData {
  final String uid;
  final String name;
  final String place;
  final int thirst;
  final String picUrl;
  final double latitude;
  final double longitude;
  final List<Place> userPlaces;
  final Timestamp update;

  UserData({this.place,this.uid,this.thirst,this.name, this.picUrl, this.userPlaces, this.latitude, this.longitude, this.update});

  List<String> getPlaces(){
    List<String> allPlaces = new List<String>();
    for (var i = 0; i < userPlaces.length; i++) {
     allPlaces.add(userPlaces[i].name);
    }
    return  allPlaces;
  }



}