import 'package:cloud_firestore/cloud_firestore.dart';
import '../DataBase/UserDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final _auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      Firestore.instance.collection('UserData');
  final String uid;
  DatabaseService({this.uid});
  Future createUserData(
    String name,
    int age,
    String gender,
    String address,
    String height,
    String weight,
    String phNo,
  ) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'age': age,
      'gender': gender,
      'address': address,
      'height': height,
      'weight': weight,
      'phNo': phNo,
    });
  }

  Future<String> getCurrentUID() async {
    return (await _auth.currentUser()).uid;
  }

  List<UserDetails> userListFromSnapshot(
    QuerySnapshot snapshot,
  ) {
    return snapshot.documents.map((doc) {
      return UserDetails(
        name: doc.data['name'] ?? '',
        gender: doc.data['gender'] ?? '',
        height: doc.data['height'] ?? '',
        weight: doc.data['weight'] ?? '',
        age: int.parse(doc.data['age']) ?? 21,
      );
    });
  }

  Stream<QuerySnapshot> get userData {
    return userCollection.snapshots();
  }
}
