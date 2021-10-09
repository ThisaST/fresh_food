import 'package:agri_tech_app/src/common/models/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

@immutable
class Vegetable extends BaseModel {
  final String? id;
  final String name;
  final String image;
  final String availability;

  Vegetable({
    required this.name,
    required this.image,
    required this.availability,
  }) : id = null;

  Vegetable copyWith({
    String? name,
    String? image,
    String? availability,
  }) {
    return Vegetable(
      name: name ?? this.name,
      image: image ?? this.image,
      availability: availability ?? this.availability,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'availability': availability,
    };
  }

  Vegetable.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        name = snapshot['name'],
        availability = snapshot['availability'],
        image = snapshot['image'];

  factory Vegetable.fromMap(Map<String, dynamic> map) {
    return Vegetable(
      name: map['name'],
      image: map['image'],
      availability: map['availability'],
    );
  }

  factory Vegetable.fromJson(Map<String, dynamic> json) =>
      _vegetableFromJson(json);

  @override
  String toString() =>
      'Vegetable(name: $name, image: $image, availability: $availability)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vegetable &&
        other.name == name &&
        other.image == image &&
        other.availability == availability;
  }

  @override
  int get hashCode => name.hashCode ^ image.hashCode ^ availability.hashCode;

  @override
  fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    final vegetable =
        Vegetable.fromJson(snapshot.data() as Map<String, dynamic>);
    vegetable.referenceId = snapshot.reference.id;
    return vegetable;
  }

  @override
  Map<String, dynamic> toJson() {
    return _vegetableToJon(this);
  }
}

Vegetable _vegetableFromJson(Map<String, dynamic> json) {
  return Vegetable(
    name: json['name'] as String,
    image: json['image'] as String,
    availability: json['availability'] as String,
  );
}

Map<String, dynamic> _vegetableToJon(Vegetable instance) => <String, dynamic>{
      'name': instance.name,
      'availability': instance.availability,
      'image': instance.image,
    };
