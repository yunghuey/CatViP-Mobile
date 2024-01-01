import 'package:CatViP/pages/report/newReport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_maps_webservice/places.dart' as webplace;
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/src/core.dart';

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
  final String gApiKey = "AIzaSyCB7cpPFXRdOFprDVVtsOts8SM5zHRaulQ";
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: Text('Current Location', style: TextStyle(color:  HexColor("#3c1e08"))),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        actions:[
          IconButton(
            onPressed: (){
              if (address!.isEmpty == true){
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please pick a location",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                );
                return;
              }
              Navigator.pop(
                  context,
                  {'latitude': latitude, 'longitude': longitude, 'address':address}
              );
              },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
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
          Container(
              margin: const EdgeInsets.all(13.0),
              child: TextFormField(
                readOnly: true,
                onTap: _handlePressedButton,
                decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    suffixIconColor: HexColor("#3c1e08"),
                    fillColor: Colors.white,
                    hintText: "Type address here...",
                    filled: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color:  HexColor("#3c1e08")),
                    )
                ),
              )

          )

        ],

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
          _updateMarkerPosition(LatLng(position.latitude, position.longitude));

          setState(() {});
        },
        tooltip: "Current Location",
        child: Icon(Icons.location_history,color: HexColor("#3c1e08")),
        backgroundColor: HexColor("#ecd9c9"),
      ),
    );
  }

  Future<void> _handlePressedButton() async {
    webplace.Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: gApiKey,
        onError: onError,
        mode: Mode.overlay,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
          hintText: "Search",
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white)),
        ),
        components: [Component(Component.country, "my")]
    );

    if (p != null){
      displayPrediction(p!, homeScaffoldKey.currentState);
    }
  }

  Future<void> displayPrediction(webplace.Prediction p, ScaffoldState? currentState) async {
    webplace.GoogleMapsPlaces places = webplace.GoogleMapsPlaces(
        apiKey: gApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    webplace.PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = latitude = detail.result.geometry!.location.lat;
    final lng = longitude = detail.result.geometry!.location.lng;
    address = "${detail.result.name!} ${detail.result.formattedAddress!}";

    markers.clear();
    //  put new marker
    markers.add(Marker(
      markerId: const MarkerId("0"),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: detail.result.name),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));

    setState(() { });
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 20.0));
  }

  void onError(webplace.PlacesAutocompleteResponse response){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.errorMessage!)));
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

    List<String> addressParts = [];
    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.postalCode != null && place.postalCode!.isNotEmpty) {
      addressParts.add(place.postalCode!);
    }
    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }
    if (place.country != null && place.country!.isNotEmpty) {
      addressParts.add(place.country!);
    }

    address = addressParts.join(', ');
    latitude = latLng.latitude;
    longitude = latLng.longitude;
  }
}