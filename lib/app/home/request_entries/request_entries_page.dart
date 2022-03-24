import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/donate/edit_request_page.dart';
import 'package:time_tracker_flutter_course/app/home/donate/list_items_builder.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/request.dart';
import 'package:time_tracker_flutter_course/app/home/request_entries/entry_list_item.dart';
import 'package:time_tracker_flutter_course/app/home/request_entries/entry_page.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class RequestEntriesPage extends StatelessWidget {
  const RequestEntriesPage({@required this.database, @required this.request});

  final Database database;
  final Request request;

  static Future<void> show(BuildContext context, Request request) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) =>
            RequestEntriesPage(database: database, request: request),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
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
      appBar: AppBar(
        elevation: 2.0,
        title: Text(request.name),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () => EditRequestPage.show(context,
                database: database, request: request),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => EntryPage.show(
              context: context,
              database: database,
              request: request,
            ),
          )
        ],
      ),
      body: _buildContent(context, request),
    );
  }

  Widget _buildContent(BuildContext context, Request request) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(request: request),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              request: request,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                request: request,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
