import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/request.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

abstract class Database {
  Future<void> setRequest(Request request);
  Future<void> deleteRequest(Request request);
  Stream<List<Request>> requestsStream();

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Request request});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setRequest(Request request) =>
      _service.setData(
        path: APIPath.request(uid, request.id),
        data: request.toMap(),
      );

  @override
  Future<void> deleteRequest(Request request) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(request: request).first;
    for (Entry entry in allEntries) {
      if (entry.requestId == request.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: APIPath.request(uid, request.id));
  }

  @override
  Stream<List<Request>> requestsStream() =>
      _service.collectionStream(
        path: APIPath.requests(uid),
        builder: (data, documentId) => Request.fromMap(data, documentId),
      );

  @override
  Future<void> setEntry(Entry entry) =>
      _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) =>
      _service.deleteData(
        path: APIPath.entry(uid, entry.id),
      );

  @override
  Stream<List<Entry>> entriesStream({Request request}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: request != null
            ? (query) => query.where('requestId', isEqualTo: request.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}

