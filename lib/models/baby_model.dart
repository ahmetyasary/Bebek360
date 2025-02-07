import 'package:cloud_firestore/cloud_firestore.dart';

class BabyModel {
  final String id;
  final String name;
  final DateTime birthDate;
  final String gender;
  final List<String> allergies;
  final String parentId;
  final Map<String, dynamic> vaccinations;
  final List<Map<String, dynamic>> growthRecords;

  BabyModel({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.allergies,
    required this.parentId,
    required this.vaccinations,
    required this.growthRecords,
  });

  factory BabyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BabyModel(
      id: doc.id,
      name: data['name'] ?? '',
      birthDate: (data['birthDate'] as Timestamp).toDate(),
      gender: data['gender'] ?? '',
      allergies: List<String>.from(data['allergies'] ?? []),
      parentId: data['parentId'] ?? '',
      vaccinations: Map<String, dynamic>.from(data['vaccinations'] ?? {}),
      growthRecords:
          List<Map<String, dynamic>>.from(data['growthRecords'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birthDate': Timestamp.fromDate(birthDate),
      'gender': gender,
      'allergies': allergies,
      'parentId': parentId,
      'vaccinations': vaccinations,
      'growthRecords': growthRecords,
    };
  }
}
