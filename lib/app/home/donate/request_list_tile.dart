
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/request.dart';

class RequestListTile extends StatelessWidget {
  const RequestListTile({Key key, @required this.request, this.onTap}) : super(key: key);
  final Request request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(request.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
