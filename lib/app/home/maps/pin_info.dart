import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PinInformation {
  String pinPath;
  LatLng location;
  String locationName;
  String address;
  String thumbNail;
  String operatingHours;

  PinInformation({this.thumbNail, this.location, this.pinPath, this.locationName, this.address, this.operatingHours});
}

final List<PinInformation> bloodCenters = [
  PinInformation(
    locationName: 'St. Lukes Medical Center - Global City',
    address: 'Rizal Drive cor. 32nd St. and, 5th Ave, Taguig, 1634 Metro Manila',
    operatingHours: 'Open 24 Hours',
    location: LatLng(14.557327294007028, 121.05241325006894),
    thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipN3H6N71sa1E80ZG4hORBQbcJcPK4jOfwzSFvso=w408-h250-k-no'
  ),
  PinInformation(
      locationName: 'The Medical City - Pasig',
      address: 'Ortigas Ave, Pasig, Metro Manila',
      operatingHours: 'Open 24 Hours',
      location: LatLng(14.591800820241696, 121.07387092140691),
      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipNfjOv_KuEZG8fkp08dPH3EbrdKw3aOA0yC2wq5=w408-h272-k-no'
  ),
];