import 'package:cloud_firestore/cloud_firestore.dart';

class Growth {
  final String id;
  final String babyId;
  final DateTime date;
  final double? weight;
  final double? height;
  final double? headCircumference;

  Growth({
    required this.id,
    required this.babyId,
    required this.date,
    this.weight,
    this.height,
    this.headCircumference,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'babyId': babyId,
      'date': Timestamp.fromDate(date),
      'weight': weight,
      'height': height,
      'headCircumference': headCircumference,
    };
  }

  factory Growth.fromMap(Map<String, dynamic> map) {
    return Growth(
      id: map['id'] as String,
      babyId: map['babyId'] as String,
      date: (map['date'] as Timestamp).toDate(),
      weight: map['weight'] as double?,
      height: map['height'] as double?,
      headCircumference: map['headCircumference'] as double?,
    );
  }
}
