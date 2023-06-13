import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.reference().child('users');
  Set<Marker> _markers = {};

  List<String> _randomNames = [
    'John',
    'Alice',
    'Bob',
    'Emma',
    'Michael',
    'Olivia',
    'William',
    'Sophia',
    'James',
    'Charlotte',
  ];

  @override
  void initState() {
    super.initState();
    getUsersLocation();
  }

  void getUsersLocation() {
    DatabaseReference usersRef =
        FirebaseDatabase.instance.reference().child('users');

    usersRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> users =
            Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);

        users.forEach((key, value) {
          if (value['latitude'] != null && value['longitude'] != null) {
            String name = value['name'];
            double latitude = value['latitude'];
            double longitude = value['longitude'];
            LatLng position = LatLng(latitude, longitude);
            _addMarker(position, name);
            print('User: $key - Latitude: $latitude, Longitude: $longitude');
          }
        });
      }
      addRandomWaypoints();
    }).catchError((error) {
      print('Failed to retrieve user locations: $error');
    });
  }

  void addRandomWaypoints() {
    Random random = Random();
    for (int i = 0; i < 5; i++) {
      double latitude = 40.7749 + random.nextDouble() / 2;
      double longitude = -8.4194 + random.nextDouble() / 2;
      String name = _randomNames[random.nextInt(_randomNames.length)];
      LatLng position = LatLng(latitude, longitude);
      _addMarker(position, name);
      print('Random Waypoint - Latitude: $latitude, Longitude: $longitude');
    }
  }

  void _addMarker(LatLng position, String name) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(title: name),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(40.7749, -8.4194),
                zoom: 10,
              ),
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
            Container(
              height: 56,
              color: Colors.grey[900],
              child: Center(
                child: Text(
                  'Alumni Map',
                  style: TextStyle(
                    color: Color(0xFF64FEDA),
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
