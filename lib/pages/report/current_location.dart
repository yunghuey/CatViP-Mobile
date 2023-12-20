import 'package:CatViP/pages/report/newReport.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';


class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition =
  CameraPosition(target: LatLng(2.3282854, 102.2929662), zoom: 14);

  Set<Marker> markers = {};
  late NewReport report;
  String address = '';
  double latitude = 0;
  double longitude = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Location', style: TextStyle(color:  HexColor("#3c1e08"))),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              // Handle the button press
              // if (address.isEmpty == true){
              //   ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(
              //         content: Text("Please pick a location",
              //           style: TextStyle(
              //             color: HexColor("#FF6464"),
              //             fontSize: 20,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         backgroundColor: HexColor("#FFE382"),
              //       )
              //   );
              //   return;
              // }

              print('TextButton pressed');
              Navigator.pop(
                  context,
                  {'latitude': latitude, 'longitude': longitude, 'address':address}
              );
            },
            child: Text(
              'SAVE', style: Theme.of(context).textTheme.bodyLarge
            ),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onTap: (LatLng latLng) {
          // Handle map tap event and update marker position
          _updateMarkerPosition(latLng);
        },
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position position = await determinePosition();
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14,
              ),
            ),
          );
          //_getAddressFromLatLng(LatLng(position.latitude, position.longitude));

          _updateMarkerPosition(LatLng(position.latitude, position.longitude));

          setState(() {});
        },
        tooltip: "Current Location",
        child: Icon(Icons.location_history,color: HexColor("#3c1e08")),
        backgroundColor: HexColor("#ecd9c9"),
      ),

    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _updateMarkerPosition(LatLng latLng) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: latLng,
      ),
    );

    // Reverse geocode to get address from the tapped location
    _getAddressFromLatLng(latLng);

    setState(() {});
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placeMark = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    Placemark place = placeMark.isNotEmpty ? placeMark.first : Placemark();

    address = '${place.name},'
        '${place.street},'
        ' ${place.subLocality},'
        ' ${place.locality},'
        ' ${place.postalCode},'
        ' ${place.country}';
    latitude = latLng.latitude;
    longitude = latLng.longitude;
  }
}