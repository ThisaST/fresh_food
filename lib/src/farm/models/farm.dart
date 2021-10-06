import 'dart:convert';

import 'package:agri_tech_app/src/common/models/base_model.dart';
import 'package:agri_tech_app/src/farm/farm_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

@immutable
class Farm extends BaseModel {
  final String? id;
  final String name;
  final double area;
  final double rating;
  final String image;
  final double price;

  Farm(
      {required this.name,
      required this.area,
      required this.rating,
      required this.image,
      required this.price})
      : id = null;

  // Farm._({this.name, this.area, this.rating, this.image, this.price})
  //     : id = null;

  Farm.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        name = snapshot['name'],
        area = snapshot['area'].toDouble(),
        rating = snapshot['rating'].toDouble(),
        price = snapshot['price'].toDouble(),
        image = snapshot['image'];

  Farm copyWith({
    String? id,
    String? name,
    double? area,
    double? rating,
    String? image,
    double? price,
  }) {
    return Farm(
      name: name ?? this.name,
      area: area ?? this.area,
      rating: rating ?? this.rating,
      image: image ?? this.image,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'rating': rating,
      'image': image,
      'price': price,
    };
  }

  factory Farm.fromMap(Map<String, dynamic> map) {
    return Farm(
      name: map['name'],
      area: map['area'],
      rating: map['rating'],
      image: map['image'],
      price: map['price'],
    );
  }

  // String toJson() => json.encode(toMap());

  // factory Farm.fromJson(String source) => Farm.fromMap(json.decode(source));

  factory Farm.fromJson(Map<String, dynamic> json) => _farmFromJson(json);

  @override
  String toString() {
    return 'Farm(id: $id, name: $name, area: $area, rating: $rating, image: $image, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Farm &&
        other.id == id &&
        other.name == name &&
        other.area == area &&
        other.rating == rating &&
        other.image == image &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        area.hashCode ^
        rating.hashCode ^
        image.hashCode ^
        price.hashCode;
  }

  @override
  fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    final newPet = Farm.fromJson(snapshot.data() as Map<String, dynamic>);
    newPet.referenceId = snapshot.reference.id;
    return newPet;
  }

  @override
  Map<String, dynamic> toJson() {
    return _farmToJson(this);
  }
}

Farm _farmFromJson(Map<String, dynamic> json) {
  return Farm(
      name: json['name'] as String,
      area: json['area'] as double,
      image: json['image'] as String,
      price: json['price'] as double,
      rating: json['rating'] as double);
}

Map<String, dynamic> _farmToJson(Farm instance) => <String, dynamic>{
      'name': instance.name,
      'area': instance.area,
      'rating': instance.rating,
      'image': instance.image,
      'price': instance.price,
      'id': instance.id
    };
