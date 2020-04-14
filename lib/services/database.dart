import 'dart:io';
import 'package:MyFirtApp_Honzin/models/person.dart';
import 'package:MyFirtApp_Honzin/models/place.dart';
import 'package:MyFirtApp_Honzin/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';


class DataBaseService {

  final String uid;
  DataBaseService({this.uid});

  //collection reference
  final CollectionReference peopleCollection = Firestore.instance.collection('people');

  Future updateUserData(String place, String name, int thirst) async {
    return await peopleCollection.document(uid).setData({
      'place': place,
      'name': name,
      'thirst': thirst,
      'picUrl': '0',
      'latitude' : 50.5654,
      'longitude': 15.9091,
      'users_places':
      [{'name':'Trut','latitude': 50.564196 ,'longitude':15.920452},
        {'name':'Irská','latitude': 50.560560 ,'longitude':15.911476},
        {'name':'Pivovarka','latitude': 50.561376 ,'longitude':15.910469},
        {'name':'Pasáž','latitude': 50.562592 ,'longitude':15.911371},
        {'name':'Nikde','latitude': 50.111 ,'longitude':15.111}],
      'update': DateTime.now()
    });
  }

  Future updateUserName(String name) async {
    return await peopleCollection.document(uid).updateData({
      'name': name
    });
  }
  Future updateUserStatus(String place, int thirst) async {
    return await peopleCollection.document(uid).updateData({
      'place': place,
      'thirst': thirst,
    });
  }

  Future updateProfilePic(String picUrl) async{
    return await peopleCollection.document(uid).updateData({
      'picUrl':picUrl
    });
  }

  Future updateLocation(double latitude,double longitude) async{
    return await peopleCollection.document(uid).updateData({
      'latitude':latitude,
      'longitude': longitude,
      'update': Timestamp.now()
    });
  }


  Future addNewLocation(String name,double latitude,double longitude) async{
    return await peopleCollection.document(uid).updateData({'users_places': FieldValue.arrayUnion([{ 'name':name,  'latitude':latitude, 'longitude':longitude}])});
  }
  Future deleteLocation(String name, double latitude, double longitude) async{
    return await peopleCollection.document(uid).updateData({'users_places': FieldValue.arrayRemove([{ 'name':name,  'latitude':latitude, 'longitude':longitude}])});
  }



  List<Person> _peopleListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Person(
        name: doc.data['name'] ?? '',
        thirst: doc.data['thirst'] ?? 0,
        place: doc.data['place'] ?? '0',
        uid: doc.documentID,
        picUrl: doc.data['picUrl'] ?? '0',
        latitude: doc.data['latitude'] ?? 0,
        longitude: doc.data['longitude'] ?? 0,
        update: doc.data['update'] ?? null,
        userPlaces: doc.data['users_places'].map<Place>((item) {
          return Place.fromMap(item);
        }).toList() ?? null,
      );
    }).toList();
  }

  Future uploadPic(BuildContext context, String fileName, File imageFile) async {
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    return await uploadTask.onComplete;
  }

  Future deletePic(String fileName) async{
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    await firebaseStorageRef.delete();

  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      place: snapshot.data['place'],
      thirst: snapshot.data['thirst'],
      picUrl: snapshot.data['picUrl'],
      userPlaces: snapshot['users_places'].map<Place>((item) {
        return Place.fromMap(item);
      }).toList(),
      longitude: snapshot.data['longitude'],
      latitude: snapshot.data['latitude'],
      update: snapshot.data['update']
    );
  }

  //get piv stream
Stream<List<Person>> get people {
    return peopleCollection.snapshots()
        .map(_peopleListFromSnapshot);
}

//get user doc stream
Stream<UserData> get userData{
    return peopleCollection.document(uid).snapshots()
        .map(_userDataFromSnapshot);
}

}