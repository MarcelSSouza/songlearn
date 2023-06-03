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
    _getUserLocations();
  }

void _getUserLocations() {
  FirebaseFirestore.instance
      .collection('users')
      .get()
      .then((QuerySnapshot snapshot) {
    if (snapshot.size > 0) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        double latitude = data['latitude'].toDouble();
        double longitude = data['longitude'].toDouble();

        _addMarker(LatLng(latitude, longitude));
      });
    }
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
