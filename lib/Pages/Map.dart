import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Initial map position
          zoom: 10, // Initial zoom level
        ),
        markers: Set<Marker>.from([
          Marker(
            markerId: MarkerId('marker_1'),
            position: LatLng(37.7749, -122.4194), // Marker position
            infoWindow: InfoWindow(title: 'Marker 1'), // Optional info window
          ),
        ]),
        onMapCreated: (GoogleMapController controller) {
          // Called when the map is created and ready to be used
          // You can perform additional map configuration here
        },
      ),
    );
  }
}
