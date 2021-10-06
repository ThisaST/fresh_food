import 'package:agri_tech_app/src/common/models/base_model.dart';
import 'package:agri_tech_app/src/farm/models/farm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Repository<T extends BaseModel> {
  String collectionName;

  Repository(this.collectionName);

  CollectionReference get collection =>
      FirebaseFirestore.instance.collection(this.collectionName);

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> add(T type) {
    return collection.add(type.toJson());
  }

  void update(T type) async {
    await collection.doc(type.referenceId).update(type.toJson());
  }

  void deletePet(T type) async {
    await collection.doc(type.referenceId).delete();
  }
}
