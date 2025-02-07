import 'package:cloud_firestore/cloud_firestore.dart';

enum FeedingType { breast, bottle, food }

class Feeding {
  final String id;
  final String babyId;
  final DateTime startTime;
  final DateTime? endTime;
  final FeedingType type;
  final double? amount;
  final String? note;

  const Feeding({
    required this.id,
    required this.babyId,
    required this.startTime,
    this.endTime,
    required this.type,
    this.amount,
    this.note,
  });

  factory Feeding.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Feeding(
      id: doc.id,
      babyId: data['babyId'] as String,
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp?)?.toDate(),
      type: FeedingType.values.firstWhere(
        (e) => e.toString() == data['type'] as String,
      ),
      amount: (data['amount'] as num?)?.toDouble(),
      note: data['note'] as String?,
    );
  }

  factory Feeding.fromMap(Map<String, dynamic> map) {
    return Feeding(
      id: map['id'] as String,
      babyId: map['babyId'] as String,
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp?)?.toDate(),
      type: FeedingType.values.firstWhere(
        (e) => e.toString() == map['type'] as String,
      ),
      amount: (map['amount'] as num?)?.toDouble(),
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'babyId': babyId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'type': type.toString(),
      'amount': amount,
      'note': note,
    };
  }

  Feeding copyWith({
    String? id,
    String? babyId,
    DateTime? startTime,
    DateTime? endTime,
    FeedingType? type,
    double? amount,
    String? note,
  }) {
    return Feeding(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      note: note ?? this.note,
    );
  }
}
