import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/request.dart';
import 'package:time_tracker_flutter_course/app/home/request_entries/date_time_picker.dart';
import 'package:time_tracker_flutter_course/app/home/request_entries/format.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EntryPage extends StatefulWidget {
  const EntryPage(
      {@required this.database, @required this.request, this.entry});

  final Database database;
  final Request request;
  final Entry entry;

  static Future<void> show(
      {BuildContext context,
      Database database,
      Request request,
      Entry entry}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EntryPage(database: database, request: request, entry: entry),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  DateTime _startDate;
  TimeOfDay _startTime;
  DateTime _endDate;
  TimeOfDay _endTime;
  String _comment;
  String _contactPerson;
  int _numBloodBags;
  String _nameDoc;

  @override
  void initState() {
    super.initState();
    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _comment = widget.entry?.comment ?? '';
    if (widget.entry != null ) {
      _contactPerson = widget.entry.contactPerson;
      _numBloodBags = widget.entry.numBloodBags;
      _nameDoc = widget.entry.nameDoc;
    }
  }

  Entry _entryFromState() {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);
    final id = widget.entry?.id ?? documentIdFromCurrentDate();
    return Entry(
        id: id,
        requestId: widget.request.id,
        start: start,
        end: end,
        comment: _comment,
        contactPerson: _contactPerson,
        numBloodBags: _numBloodBags,
        nameDoc: _nameDoc);
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database.setEntry(entry);
      Navigator.of(context).pop();
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
        title: Text(widget.request.name),
        actions: <Widget>[
          FlatButton(
            child: Text(
              widget.entry != null ? 'Update' : 'Create',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildEntry(), // has all other info
              _buildEndDate(),
              SizedBox(height: 12.0),
              _buildComment(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartDate() {
    return DateTimePicker(
      selectedDate: _startDate,
      selectedTime: _startTime,
      selectDate: (date) => setState(() => _startDate = date),
      selectTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'On or before the time and date Needed',
      selectedDate: _endDate,
      selectedTime: _endTime,
      selectDate: (date) => setState(() => _endDate = date),
      selectTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildDuration() {
    final currentEntry = _entryFromState();
    final durationFormatted = Format.hours(currentEntry.durationInHours);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Duration: $durationFormatted',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _comment),
      decoration: InputDecoration(
        labelText: 'Other Requests?',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
    );
  }

  Widget _buildEntry() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildEntryChildren(),
      ),
    );
  }

  List<Widget> _buildEntryChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Contact Person'),
        initialValue: _contactPerson,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onChanged: (contactPerson) => _contactPerson = contactPerson,
      ),
      SizedBox(height: 12.0),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Number of Blood Bags',
          border: const OutlineInputBorder(),
          hintText: '1, 2, 3..',
        ),
        initialValue: _numBloodBags != null ? '$_numBloodBags' : null,
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        onChanged: (numBloodBags) => _numBloodBags = int.tryParse(numBloodBags) ?? 63,
      ),
      SizedBox(height: 12.0),

      TextFormField(
        decoration:
            InputDecoration(labelText: 'Name of Doctor', hintText: 'Dr.'),
        initialValue: _nameDoc,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onChanged: (nameDoc) => _nameDoc = nameDoc,
      ),
    ];
  }
}
