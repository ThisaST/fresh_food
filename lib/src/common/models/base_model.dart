import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseModel {
  String? referenceId;
  Map<String, dynamic> toJson();
  fromSnapshot(DocumentSnapshot snapshot);
}
