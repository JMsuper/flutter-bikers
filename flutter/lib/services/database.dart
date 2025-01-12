import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  // collection reference
  final CollectionReference bikerCollection =
      FirebaseFirestore.instance.collection('User collection');

  Future updateUserData(String name, int age) async {
    return await bikerCollection.doc(uid).set({'name': name, 'age': age});
  }
}
