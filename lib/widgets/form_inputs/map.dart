import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/item.dart';

class ItemMap extends StatefulWidget {
  final Item item;

  ItemMap(this.item);

  @override
  State<StatefulWidget> createState() {
    return _ItemMapState(item);
  }


}

class _ItemMapState extends State<ItemMap> {
  Item item;

  _ItemMapState(this.item);

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              tooltip: 'Locate',
              heroTag: 'Locate',
              backgroundColor: Colors.white,
              child: Icon(
                Icons.gps_fixed,
                color: Colors.black,
              ),
              onPressed: () {
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(5.596860, -0.223293),
                        zoom: 20.0,
                        tilt: 60.0,
                        bearing: 50.0),
                  ),
                );
                mapController.addMarker(
                  MarkerOptions(
                    position: LatLng(5.596860, -0.223293),
                    infoWindowText: InfoWindowText(
                        item.title, 'GH₵' + item.price.toString()),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
                  ),
                );
              },
            )),
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: FloatingActionButton(
            tooltip: 'Back',
            heroTag: 'Back',
            child: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(height: 30.0,),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
