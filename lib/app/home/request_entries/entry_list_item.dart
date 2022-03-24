import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/request.dart';
import 'package:time_tracker_flutter_course/app/home/request_entries/format.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem({
    @required this.entry,
    @required this.request,
    @required this.onTap,
  });

  final Entry entry;
  final Request request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final dayOfWeek = Format.dayOfWeek(entry.start);
    final startDate = Format.date(entry.start);
    final endDate = Format.date(entry.end);
    final startTime = TimeOfDay.fromDateTime(entry.start).format(context);
    final endTime = TimeOfDay.fromDateTime(entry.end).format(context);
    final durationFormatted = Format.hours(entry.durationInHours);
    final bloodBags = (entry.numBloodBags);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(entry.contactPerson,
              style: TextStyle(fontSize: 18.0, color: Colors.black87)),
          SizedBox(width: 15.0),
          Expanded(child: Container()),
        ]),
            Row(children: <Widget>[
              Text('$endDate - $endTime', style: TextStyle(fontSize: 16.0)),
              Expanded(child: Container()),
              Text('Bags Needed: $bloodBags', style: TextStyle(fontSize: 14.0, color: Colors.red)),
            ]),
        if (entry.nameDoc.isNotEmpty)
          Row(
            children: <Widget>[
              Text(
                'Dr. ' + entry.nameDoc,
                style: TextStyle(fontSize: 12.0),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Expanded(child: Container()),
              Text(request.hospitalName, style: TextStyle(fontSize: 14.0, color: Colors.green))
            ],
          )
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    this.key,
    this.entry,
    this.request,
    this.onDismissed,
    this.onTap,
  });

  final Key key;
  final Entry entry;
  final Request request;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: EntryListItem(
        entry: entry,
        request: request,
        onTap: onTap,
      ),
    );
  }
}
