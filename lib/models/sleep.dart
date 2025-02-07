import 'package:cloud_firestore/cloud_firestore.dart';

class Sleep {
  final String id;
  final String babyId;
  final DateTime startTime;
  final DateTime? endTime;
  final String? note;

  const Sleep({
    required this.id,
    required this.babyId,
    required this.startTime,
    this.endTime,
    this.note,
  });

  factory Sleep.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Sleep(
      id: doc.id,
      babyId: data['babyId'] as String,
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp?)?.toDate(),
      note: data['note'] as String?,
    );
  }

  factory Sleep.fromMap(Map<String, dynamic> map) {
    return Sleep(
      id: map['id'] as String,
      babyId: map['babyId'] as String,
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp?)?.toDate(),
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'babyId': babyId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'note': note,
    };
  }

  Sleep copyWith({
    String? id,
    String? babyId,
    DateTime? startTime,
    DateTime? endTime,
    String? note,
  }) {
    return Sleep(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      note: note ?? this.note,
    );
  }
}
