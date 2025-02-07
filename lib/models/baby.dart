import 'package:cloud_firestore/cloud_firestore.dart';
import 'feeding.dart';
import 'diaper.dart';
import 'sleep.dart';
import 'growth.dart';
import 'moment.dart';
import 'vaccine.dart';
import 'allergy.dart';

class Baby {
  final String id;
  final String name;
  final DateTime birthDate;
  final String? photoUrl;
  final List<Feeding> feedings;
  final List<Diaper> diapers;
  final List<Sleep> sleeps;
  final List<Growth> growthMeasurements;
  final List<Moment> moments;
  final List<Vaccine> vaccines;
  final List<Allergy> allergies;

  Baby({
    required this.id,
    required this.name,
    required this.birthDate,
    this.photoUrl,
    this.feedings = const [],
    this.diapers = const [],
    this.sleeps = const [],
    this.growthMeasurements = const [],
    this.moments = const [],
    this.vaccines = const [],
    this.allergies = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': Timestamp.fromDate(birthDate),
      'photoUrl': photoUrl,
    };
  }

  factory Baby.fromMap(Map<String, dynamic> map) {
    return Baby(
      id: map['id'] as String,
      name: map['name'] as String,
      birthDate: (map['birthDate'] as Timestamp).toDate(),
      photoUrl: map['photoUrl'] as String?,
    );
  }

  Baby copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    String? photoUrl,
    List<Feeding>? feedings,
    List<Diaper>? diapers,
    List<Sleep>? sleeps,
    List<Growth>? growthMeasurements,
    List<Moment>? moments,
    List<Vaccine>? vaccines,
    List<Allergy>? allergies,
  }) {
    return Baby(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      photoUrl: photoUrl ?? this.photoUrl,
      feedings: feedings ?? this.feedings,
      diapers: diapers ?? this.diapers,
      sleeps: sleeps ?? this.sleeps,
      growthMeasurements: growthMeasurements ?? this.growthMeasurements,
      moments: moments ?? this.moments,
      vaccines: vaccines ?? this.vaccines,
      allergies: allergies ?? this.allergies,
    );
  }

  Feeding? get lastFeeding => feedings.isNotEmpty ? feedings.last : null;
  Diaper? get lastDiaper => diapers.isNotEmpty ? diapers.last : null;
  Sleep? get lastSleep => sleeps.isNotEmpty ? sleeps.last : null;
  List<Allergy> get activeAllergies =>
      allergies.where((a) => a.isActive).toList();
  List<Allergy> get severeAllergies => allergies
      .where((a) => a.severity == AllergySeverity.severe && a.isActive)
      .toList();
}
