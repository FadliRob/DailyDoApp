import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');
  Stream<QuerySnapshot> gettasks() {
    final tasksStream = tasks.snapshots();
    return tasksStream;
  }

  final CollectionReference completes =
      FirebaseFirestore.instance.collection('completes');
  Stream<QuerySnapshot> getcompletes() {
    final completesStream = completes.snapshots();
    return completesStream;
  }
}
