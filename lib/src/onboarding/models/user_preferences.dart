import 'dart:convert';

import 'package:agri_tech_app/src/common/models/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreference extends BaseModel {
  final String? userId;
  final num familyMembersCount;
  final String selectedDiet;
  UserPreference({
    required this.userId,
    required this.familyMembersCount,
    required this.selectedDiet,
  });

  UserPreference copyWith({
    String? userId,
    num? familyMembersCount,
    String? selectedDiet,
  }) {
    return UserPreference(
      userId: userId ?? this.userId,
      familyMembersCount: familyMembersCount ?? this.familyMembersCount,
      selectedDiet: selectedDiet ?? this.selectedDiet,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'familyMembersCount': familyMembersCount,
      'selectedDiet': selectedDiet,
    };
  }

  factory UserPreference.fromMap(Map<String, dynamic> map) {
    return UserPreference(
      userId: map['userId'],
      familyMembersCount: map['familyMembersCount'],
      selectedDiet: map['selectedDiet'],
    );
  }

  factory UserPreference.fromJson(Map<String, dynamic> json) =>
      _userPreferenceFromJson(json);

  @override
  String toString() =>
      'UserPreference(userId: $userId, familyMembersCount: $familyMembersCount, selectedDiet: $selectedDiet)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserPreference &&
        other.userId == userId &&
        other.familyMembersCount == familyMembersCount &&
        other.selectedDiet == selectedDiet;
  }

  @override
  int get hashCode =>
      userId.hashCode ^ familyMembersCount.hashCode ^ selectedDiet.hashCode;

  @override
  fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    final newPet =
        UserPreference.fromJson(snapshot.data() as Map<String, dynamic>);
    newPet.referenceId = snapshot.reference.id;
    return newPet;
  }

  @override
  Map<String, dynamic> toJson() {
    return _userPreferenceToJson(this);
  }
}

UserPreference _userPreferenceFromJson(Map<String, dynamic> json) {
  return UserPreference(
    userId: json['userId'] as String,
    familyMembersCount: json['familyMembersCount'] as num,
    selectedDiet: json['selectedDiet'] as String,
  );
}

Map<String, dynamic> _userPreferenceToJson(UserPreference instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'familyMembersCount': instance.familyMembersCount,
      'selectedDiet': instance.selectedDiet,
    };
