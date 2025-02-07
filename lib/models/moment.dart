import 'package:cloud_firestore/cloud_firestore.dart';

class Moment {
  final String id;
  final String babyId;
  final String photoUrl;
  final String? note;
  final DateTime timestamp;

  Moment({
    required this.id,
    required this.babyId,
    required this.photoUrl,
    this.note,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'babyId': babyId,
      'photoUrl': photoUrl,
      'note': note,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory Moment.fromMap(Map<String, dynamic> map) {
    return Moment(
      id: map['id'] as String,
      babyId: map['babyId'] as String,
      photoUrl: map['photoUrl'] as String,
      note: map['note'] as String?,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
