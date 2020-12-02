import 'package:migsmarketplace/models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  DatabaseService({
    this.uid,
  });

  final String uid;

  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Stream<CustomerData> get merchantData {
    return _users
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot snapshot) => CustomerData(
          id: uid,
          name: snapshot.data()['name'],
          phone: snapshot.data()['phone'],
          email: snapshot.data()['email'],
      ),
    );
  }



}
