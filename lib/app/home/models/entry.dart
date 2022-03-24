import 'package:flutter/foundation.dart';

class Entry {
  Entry({
    @required this.id,
    @required this.requestId,
    @required this.start,
    this.end,
    this.tNow,
    @required this.contactPerson,
    @required this.numBloodBags,
    @required this.nameDoc,
    this.comment,

  });

  String id;
  String requestId;
  DateTime start;
  DateTime end;
  DateTime tNow;
  String comment;
  String contactPerson;
  int numBloodBags;
  String nameDoc;

  double get durationInHours =>
      end.difference(tNow).inMinutes.toDouble() / 60.0;

  factory Entry.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    final String contactPerson = value['contactPerson'];
    final String nameDoc = value['nameDoc'];
    final int numBloodBags = value['numBloodBags'];
    return Entry(
      id: id,
      requestId: value['requestId'],
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      tNow: DateTime.now(),
      comment: value['comment'],
      contactPerson: contactPerson,
      numBloodBags: numBloodBags,
      nameDoc: nameDoc,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'requestId': requestId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'tNow': tNow,
      'comment': comment,
      'contactPerson': contactPerson,
      'numBloodBags': numBloodBags,
      'nameDoc': nameDoc,
    };
  }
}
