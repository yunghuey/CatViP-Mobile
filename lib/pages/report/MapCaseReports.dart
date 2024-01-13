import 'dart:ffi';

import 'package:CatViP/pages/report/newReport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../bloc/report case/GetOwnCase/getOwnCase_bloc.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_event.dart';
import '../../bloc/report case/GetOwnCase/getOwnCase_state.dart';
import '../../model/caseReport/caseReport.dart';
import 'ReportDetails.dart';


class MapCaseReports extends StatefulWidget {
  const MapCaseReports({super.key});

  @override
  State<MapCaseReports> createState() => _MapCaseReportsState();
}

class _MapCaseReportsState extends State<MapCaseReports> {
  late GoogleMapController googleMapController;
  static CameraPosition initialCameraPosition =
  CameraPosition(target: LatLng(0.0, 0.0), zoom: 14);
  final GetCaseBloc caseBloc = GetCaseBloc();

  Set<Marker> markers = {};
  late NewReport report;
  String address = '';
  double latitude = 0;
  double longitude = 0;
  late List<CaseReport> nearbyReports;
  late Set<Circle> circle = {};

  @override
  void initState() {
    // TODO: implement initState
    caseBloc.add(GetCaseList());
    //_fetchNearbyReports();
    _setInitialLocation();
    super.initState();
  }

  Future<void> _setInitialLocation() async {
    try {
      Position position = await determinePosition();
      initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14,
      );

      circle = {Circle(
        circleId: CircleId("current_position"),
        center: LatLng(position.latitude, position.longitude),
        radius: 80,
        fillColor: HexColor("#f6ba00").withOpacity(0.6),
        strokeColor:HexColor("#3c1e08"),
        strokeWidth: 3,
      )};

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
    } catch (e) {
      print('Error setting initial location: $e');
      if (e == "Location services are disabled."){
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You must allow location access to view missing case report")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => caseBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cases Around You', style: TextStyle(color: HexColor("#3c1e08"))),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
        ),
        body: BlocListener<GetCaseBloc, GetCaseState>(
          listener: (context, state) {
            if (state is GetCaseInitial) {
              CircularProgressIndicator(color: HexColor("#3c1e08"));
            } else if (state is GetCaseLoading) {
              CircularProgressIndicator(color: HexColor("#3c1e08"));
            } else if (state is GetCaseLoaded) {
              nearbyReports = state.caseList;
              print("Number of nearby reports: ${nearbyReports.length}");

              // Set the initial camera position to the first nearby report
              if (nearbyReports.isNotEmpty) {
                initialCameraPosition = CameraPosition(
                  target: LatLng(nearbyReports[0].latitude!, nearbyReports[0].longitude!),
                  zoom: 14,
                );
              }

              // Update markers on the map
              final Set<Marker> nearbyMarkers = nearbyReports.map((report) {
                return Marker(
                  markerId: MarkerId(report.id.toString()),
                  position: LatLng(report.latitude!, report.longitude!),
                );
              }).toSet();

              markers.addAll(nearbyMarkers);
              print("Number of nearby markers: ${nearbyMarkers.length}");
              setState(() {});
            } else if (state is GetCaseError) {
              // Handle error
              print('Error fetching nearby reports: ${state.error}');
            }
          },
          child: GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onTap: (LatLng latLng) {
              _updateMarkerPosition(latLng);
            },
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
            circles: circle,
          ),
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
          child: Icon(Icons.location_history, color: HexColor("#3c1e08")),
          backgroundColor: HexColor("#ecd9c9"),
        ),
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
    return await Geolocator.getCurrentPosition();
  }

  void _updateMarkerPosition(LatLng latLng) {
    markers.clear();
    // markers.add(
    //   Marker(
    //     markerId: const MarkerId('currentLocation'),
    //     position: latLng,
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    //   ),
    // );

    // Add other markers (nearbyReports markers)
    markers.addAll(nearbyReports.map((report) {
      return Marker(
        markerId: MarkerId(report.id.toString()),
        position: LatLng(report.latitude!, report.longitude!),
        onTap: () {
          _onMarkerTapped(report);
        }
      );
    }).toSet());

    setState(() {});
  }

  void _onMarkerTapped(CaseReport tappedReport) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDetail(caseReport: tappedReport),
      ),
    );
  }

}