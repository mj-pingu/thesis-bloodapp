import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/donate/edit_request_page.dart';
import 'package:time_tracker_flutter_course/app/home/donate/list_items_builder.dart';
import 'package:time_tracker_flutter_course/app/home/donate/request_list_tile.dart';
import 'package:time_tracker_flutter_course/app/home/models/request.dart';
import 'package:time_tracker_flutter_course/app/home/request_entries/request_entries_page.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class RequestForm extends StatelessWidget {


  Future<void> _delete(BuildContext context, Request request) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteRequest(request);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Blood Requests',
          style: TextStyle(
              fontSize: 25.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add, color: Colors.white),
            onPressed: () =>
                EditRequestPage.show(
                  context,
                  database: Provider.of<Database>(context, listen: false),
                ),
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Request>>(
      stream: database.requestsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Request>(
          snapshot: snapshot,
          itemBuilder: (context, request) =>
              Dismissible(
                key: Key('request-${request.id}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => _delete(context, request),
                child: RequestListTile(
                  request: request,
                  onTap: () => RequestEntriesPage.show(context, request),
                ),
              ),
        );
      },
    );
  }
}
