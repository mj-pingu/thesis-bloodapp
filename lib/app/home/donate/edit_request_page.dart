import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/request.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditRequestPage extends StatefulWidget {
  const EditRequestPage({Key key, @required this.database, this.request}) : super(key: key);
  final Database database;
  final Request request;

  static Future<void> show(BuildContext context, {Database database, Request request}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditRequestPage(database: database, request: request),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditRequestPageState createState() => _EditRequestPageState();
}

class _EditRequestPageState extends State<EditRequestPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  int _mobNum;
  String _bloodType;
  String _hospitalName;


  @override
  void initState() {
    super.initState();
    if (widget.request != null ){
      _name = widget.request.name;
      _mobNum = widget.request.mobNum;
      _bloodType = widget.request.bloodType;
      _hospitalName = widget.request.hospitalName;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  Future<void> _submit() async {
    if (_validateAndSaveForm()){
      try {
        final requests = await widget.database.requestsStream().first;
        final allNames = requests.map((request) => request.name).toList();
        if (widget.request != null) {
          allNames.remove(widget.request.name);
        }
        if (allNames. contains(_name)) {
          showAlertDialog(context, title: 'Multiple Names Detected', content: 'Please Confirm Different Name', defaultActionText: 'OK');
        } else {
          final id = widget.request?.id ?? documentIdFromCurrentDate();
          final request = Request(
              id: id,
              name: _name,
              mobNum: _mobNum,
              bloodType: _bloodType,
              hospitalName: _hospitalName);
          await widget.database.setRequest(request);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context, title: 'Operation Failed', exception: e);
      }
    }
    // TODO: Validate & save the form to firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.request == null ? 'Blood Request' : 'Edit Request'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          )
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Patient Name', border: const OutlineInputBorder()),
            initialValue: _name,
            validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
            onSaved: (value) => _name = value,
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Mobile Number', border: const OutlineInputBorder()),
        initialValue: _mobNum != null ? '$_mobNum' : null ,
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        onSaved: (value) => _mobNum = int.tryParse(value) ?? 63,
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Blood Type', border: const OutlineInputBorder()),
            initialValue: _bloodType,
            validator: (value) => value.isNotEmpty ? null : 'Blood Type can\'t be empty',
            onSaved: (value) => _bloodType = value,
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Hospital Name',
          border: const OutlineInputBorder(),
        ),
        initialValue: _hospitalName,
        onSaved: (value) => _hospitalName = value,
      ),
    ];
  }
}
