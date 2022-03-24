import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_tracker_flutter_course/app/home/maps/pin_info.dart';

class MapPage extends StatelessWidget {
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> allMarkers = [];
  PageController _pageController;
  int prevPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            'Blood Centers',
            style: TextStyle(
                fontSize: 25.0,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            _googleMap(context),
          ],
        )
    );
  }

  void initState() {
    bloodCenters.forEach((element) {
      allMarkers.add(Marker(
          markerId: MarkerId(element.locationName),
          draggable: false,
          infoWindow:
          InfoWindow(title: element.locationName, snippet: element.address),
          position: element.location
      ));
      _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
        ..addListener(_onScroll);
    });
  }


  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      //moveCamera();
    }
  }

  _bloodCenterList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            //moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 125.0,
                    width: 275.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          bloodCenters[index].thumbNail),
                                      fit: BoxFit.cover))),
                          SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bloodCenters[index].locationName,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  bloodCenters[index].address,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width: 170.0,
                                  child: Text(
                                    bloodCenters[index].operatingHours,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ])
                        ]))))
          ])),
    );
  }


  Widget _googleMap(BuildContext context) {
    return Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target: LatLng(14.572404933453537, 121.0469200862064), zoom: 12),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: {bc1, bc2, bc3, bc4, bc5},
        )
    );
  }
}

Marker bc1 = Marker(
  markerId: MarkerId('bc1'),
  position: LatLng(14.557327294007028, 121.05241325006894),
  infoWindow: InfoWindow(title: 'St. Lukes Medical Center - Global City'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker bc2 = Marker(
  markerId: MarkerId('bc2'),
  position: LatLng(14.591800820241696, 121.07387092140691),
  infoWindow: InfoWindow(title: 'The Medical City - Pasig'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker bc3 = Marker(
  markerId: MarkerId('bc3'),
  position: LatLng(14.559190738959465, 121.0145583825071),
  infoWindow: InfoWindow(title: 'Makati Medical Center'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker bc4 = Marker(
  markerId: MarkerId('bc4'),
  position: LatLng(14.572915876832612, 121.04686938477754),
  infoWindow: InfoWindow(title: 'Philippine Red Cross National Blood Center'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker bc5 = Marker(
  markerId: MarkerId('bc5'),
  position: LatLng(14.53283957829792, 121.00461864484535),
  infoWindow: InfoWindow(title: 'Philippine Red Cross Pasay City Chapter'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);
