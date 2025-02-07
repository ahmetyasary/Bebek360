import 'package:cloud_firestore/cloud_firestore.dart';

enum DiaperType { wet, dirty, both }

class Diaper {
  final String id;
  final String babyId;
  final DateTime time;
  final DiaperType type;
  final String? note;

  const Diaper({
    required this.id,
    required this.babyId,
    required this.time,
    required this.type,
    this.note,
  });

  factory Diaper.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Diaper(
      id: doc.id,
      babyId: data['babyId'] as String,
      time: (data['time'] as Timestamp).toDate(),
      type: DiaperType.values.firstWhere(
        (e) => e.toString() == data['type'] as String,
      ),
      note: data['note'] as String?,
    );
  }

  factory Diaper.fromMap(Map<String, dynamic> map) {
    return Diaper(
      id: map['id'] as String,
      babyId: map['babyId'] as String,
      time: (map['time'] as Timestamp).toDate(),
      type: DiaperType.values.firstWhere(
        (e) => e.toString() == map['type'] as String,
      ),
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'babyId': babyId,
      'time': Timestamp.fromDate(time),
      'type': type.toString(),
      'note': note,
    };
  }

  Diaper copyWith({
    String? id,
    String? babyId,
    DateTime? time,
    DiaperType? type,
    String? note,
  }) {
    return Diaper(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      time: time ?? this.time,
      type: type ?? this.type,
      note: note ?? this.note,
    );
  }
}
