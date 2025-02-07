import 'package:cloud_firestore/cloud_firestore.dart';

enum FeedingType { breastMilk, formula, food }

class FeedingRecord {
  final String id;
  final String babyId;
  final DateTime timestamp;
  final FeedingType type;
  final double amount; // ml veya gram
  final String? note;
  final Map<String, dynamic>? reaction; // alerji, duygu durumu vb.

  FeedingRecord({
    required this.id,
    required this.babyId,
    required this.timestamp,
    required this.type,
    required this.amount,
    this.note,
    this.reaction,
  });

  factory FeedingRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedingRecord(
      id: doc.id,
      babyId: data['babyId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      type: FeedingType.values.firstWhere(
        (e) => e.toString() == data['type'],
        orElse: () => FeedingType.breastMilk,
      ),
      amount: (data['amount'] ?? 0).toDouble(),
      note: data['note'],
      reaction: data['reaction'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'babyId': babyId,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type.toString(),
      'amount': amount,
      'note': note,
      'reaction': reaction,
    };
  }
}
