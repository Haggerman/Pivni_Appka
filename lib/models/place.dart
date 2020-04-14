class Place {

  final String name;
  final double latitude;
  final double longitude;

  Place.fromMap(Map<dynamic, dynamic> data)
      : name = data['name'],  latitude = data['latitude'], longitude = data['longitude'];


  Place({this.name, this.latitude, this.longitude});

}