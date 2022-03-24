
import 'package:flutter/foundation.dart';

class Request {
  Request({@required this.id, @required this.name, @required this.bloodType, @required this.hospitalName, @required this.mobNum});
  final String id;
  final String name;
  final String bloodType;
  final int mobNum;
  final String hospitalName;

  factory Request.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int mobNum = data['mobNum'];
    final String bloodType = data['bloodType'];
    final String hospitalName = data['hospitalName'];
    return Request(
      id: documentId,
      name: name,
      mobNum: mobNum,
      bloodType: bloodType,
      hospitalName: hospitalName
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bloodType': bloodType,
      'mobNum': mobNum,
      'hospitalName': hospitalName
    };
  }
}