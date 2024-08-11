// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/style.dart';

class MapScreen extends StatefulWidget {
  final double lat, long;
  const MapScreen({Key? key, this.lat = 0, this.long = 0}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      markers: Set.from({
        Marker(
            markerId: MarkerId("${widget.lat}/${widget.long}"),
            position: LatLng(widget.lat, widget.long))
      }),
      onTap: (argument) {
        print(argument);
      },
      mapType: MapType.normal,
      zoomGesturesEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.lat, widget.long),
        zoom: 15,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(styleMap);
  }
}
