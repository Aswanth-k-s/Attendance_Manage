import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? mapController;
  LatLng _initialPosition = LatLng(10.8505159, 76.2710833);
  Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;

  Future<void> _goToCurrentLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    loc.LocationData locationData = await location.getLocation();

    LatLng currentLatLng = LatLng(
      locationData.latitude ?? _initialPosition.latitude,
      locationData.longitude ?? _initialPosition.longitude,
    );

    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId("currentLocation"),
          position: currentLatLng,
          infoWindow: InfoWindow(title: "You are here"),
        ),
      };
    });

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Current Location"),
        actions: [
          DropdownButton<MapType>(
            underline: Container(),
            value: _currentMapType,
            items:
                [
                  MapType.normal,
                  MapType.hybrid,
                  MapType.terrain,
                  MapType.satellite,
                ].map((mapType) {
                  return DropdownMenuItem(
                    value: mapType,
                    child: Text(mapType.toString().split('.').last),
                  );
                }).toList(),
            onChanged: (mapType) {
              setState(() {
                _currentMapType = mapType!;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12,
            ),
            mapType: _currentMapType,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) => mapController = controller,
            markers: _markers,
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: Colors.white,
              child: Icon(Icons.my_location, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
