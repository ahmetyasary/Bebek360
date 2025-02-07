import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? photoUrl;
  final DateTime createdAt;
  final List<String> roles; // anne, baba, vb.

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.photoUrl,
    required this.createdAt,
    required this.roles,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      roles: List<String>.from(data['roles'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'roles': roles,
    };
  }
}
