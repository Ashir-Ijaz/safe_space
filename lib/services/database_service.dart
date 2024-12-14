import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_space/models/users_db.dart';

const String USERSDB_COLLECTION_REF = 'users';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _usersdbRef;
  DatabaseService() {
    _usersdbRef = _firestore
        .collection(USERSDB_COLLECTION_REF)
        .withConverter<UsersDb>(
            fromFirestore: (snapshots, _) =>
                UsersDb.fromJson(snapshots.data()!),
            toFirestore: (UsersDb, _) => UsersDb.toJson());
  }

  Stream<QuerySnapshot> getUsers() {
    return _usersdbRef.snapshots();
  }

  void addUser(UsersDb user) async {
    try {
      await _usersdbRef.add(user.toJson());
      print("User added successfully");
    } catch (e) {
      print("Error adding user: $e");
    }
  }
}
