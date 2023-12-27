import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/src/core.dart';
import 'package:hexcolor/hexcolor.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(2.30833, 102.31767), zoom: 14.0);
  final String gApiKey = "AIzaSyCB7cpPFXRdOFprDVVtsOts8SM5zHRaulQ";
  Set<Marker> markerList = {};
  late double? userLat;
  late double? userLng;
  late String? userAddress = "";
  final Mode _mode = Mode.overlay;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: Text("Pick address",style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
          actions: [
           IconButton(
               onPressed: (){
                  if (userAddress!.isEmpty == true){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Please pick a location",
                            style: TextStyle(
                              color: HexColor("#FF6464"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: HexColor("#FFE382"),
                      )
                    );
                return;
              }
              Navigator.pop(context, { 'lat': userLat, 'lng': userLng, 'address': userAddress });
           },
               icon: Icon(Icons.done_rounded),
           )
         ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markerList,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller){
              googleMapController = controller;
            },
          ),
          Container(
            margin: const EdgeInsets.only(left: 5),
            child: ElevatedButton(
              onPressed: _handlePressedButton,
              child: Icon(Icons.search),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#3c1e08")),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)), // Adjust the size of the button
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handlePressedButton() async {

    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: gApiKey,
      onError: onError,
      mode: _mode,
      language: 'en',
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
          hintText: "Search",
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
      ),
      components: [Component(Component.country, "my")]
    );

    if (p != null){
      displayPrediction(p!, homeScaffoldKey.currentState);
    }
  }

  void onError(PlacesAutocompleteResponse response){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {
    print("display prediction");
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: gApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = userLat = detail.result.geometry!.location.lat;
    final lng = userLng = detail.result.geometry!.location.lng;
    userAddress = "${detail.result.name!} ${detail.result.formattedAddress!}";

    markerList.clear();
    //  put new marker
    markerList.add(Marker(
      markerId: const MarkerId("0"),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: detail.result.name),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));

    setState(() { });
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 20.0));
  }
}
