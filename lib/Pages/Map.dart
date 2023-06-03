import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.reference().child('users');

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    getUsersLocation();
  }

void getUsersLocation() {
  DatabaseReference usersRef = FirebaseDatabase.instance.reference().child('users');

  usersRef.once().then((DatabaseEvent event) {
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> users = Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);

      users.forEach((key, value) {
        if (value['latitude'] != null && value['longitude'] != null) {
          double latitude = value['latitude'];
          double longitude = value['longitude'];
          LatLng position = LatLng(latitude, longitude);
          _addMarker(position);

          // Do something with the latitude and longitude values
          print('User: $key - Latitude: $latitude, Longitude: $longitude');
        }
      });
    }
  }).catchError((error) {
    // Handle error
    print('Failed to retrieve user locations: $error');
  });
}

  void _addMarker(LatLng position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(title: 'User Location'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 10,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
