import 'package:cloud_firestore/cloud_firestore.dart';

enum AllergySeverity { mild, moderate, severe }

enum AllergyType { food, medicine, environmental, other }

class Allergy {
  final String id;
  final String babyId;
  final String name;
  final AllergyType type;
  final AllergySeverity severity;
  final DateTime diagnosisDate;
  final String? symptoms;
  final String? treatment;
  final String? notes;
  final bool isActive;

  const Allergy({
    required this.id,
    required this.babyId,
    required this.name,
    required this.type,
    required this.severity,
    required this.diagnosisDate,
    this.symptoms,
    this.treatment,
    this.notes,
    this.isActive = true,
  });

  factory Allergy.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Allergy(
      id: doc.id,
      babyId: data['babyId'] as String,
      name: data['name'] as String,
      type: AllergyType.values.firstWhere(
        (e) => e.toString() == data['type'] as String,
      ),
      severity: AllergySeverity.values.firstWhere(
        (e) => e.toString() == data['severity'] as String,
      ),
      diagnosisDate: (data['diagnosisDate'] as Timestamp).toDate(),
      symptoms: data['symptoms'] as String?,
      treatment: data['treatment'] as String?,
      notes: data['notes'] as String?,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'babyId': babyId,
      'name': name,
      'type': type.toString(),
      'severity': severity.toString(),
      'diagnosisDate': Timestamp.fromDate(diagnosisDate),
      'symptoms': symptoms,
      'treatment': treatment,
      'notes': notes,
      'isActive': isActive,
    };
  }

  Allergy copyWith({
    String? id,
    String? babyId,
    String? name,
    AllergyType? type,
    AllergySeverity? severity,
    DateTime? diagnosisDate,
    String? symptoms,
    String? treatment,
    String? notes,
    bool? isActive,
  }) {
    return Allergy(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      name: name ?? this.name,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      diagnosisDate: diagnosisDate ?? this.diagnosisDate,
      symptoms: symptoms ?? this.symptoms,
      treatment: treatment ?? this.treatment,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }
}
