import 'package:cloud_firestore/cloud_firestore.dart';

class Vaccine {
  final String id;
  final String babyId;
  final String name;
  final DateTime date;
  final String? note;
  final bool isDone;
  final DateTime? doneDate;

  Vaccine({
    required this.id,
    required this.babyId,
    required this.name,
    required this.date,
    this.note,
    this.isDone = false,
    this.doneDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'babyId': babyId,
      'name': name,
      'date': Timestamp.fromDate(date),
      'note': note,
      'isDone': isDone,
      'doneDate': doneDate != null ? Timestamp.fromDate(doneDate!) : null,
    };
  }

  factory Vaccine.fromMap(Map<String, dynamic> map) {
    return Vaccine(
      id: map['id'] as String,
      babyId: map['babyId'] as String,
      name: map['name'] as String,
      date: (map['date'] as Timestamp).toDate(),
      note: map['note'] as String?,
      isDone: map['isDone'] as bool,
      doneDate: map['doneDate'] != null
          ? (map['doneDate'] as Timestamp).toDate()
          : null,
    );
  }

  Vaccine copyWith({
    String? id,
    String? babyId,
    String? name,
    DateTime? date,
    String? note,
    bool? isDone,
    DateTime? doneDate,
  }) {
    return Vaccine(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      name: name ?? this.name,
      date: date ?? this.date,
      note: note ?? this.note,
      isDone: isDone ?? this.isDone,
      doneDate: doneDate ?? this.doneDate,
    );
  }
}
