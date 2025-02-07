import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PhotoService {
  static final PhotoService _instance = PhotoService._();
  static PhotoService get instance => _instance;

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  PhotoService._();

  Future<File?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? quality,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    return null;
  }

  Future<String?> uploadBabyPhoto(
      String userId, String babyId, File photo) async {
    try {
      final ref = _storage
          .ref()
          .child('users')
          .child(userId)
          .child('babies')
          .child(babyId)
          .child('profile.jpg');

      final uploadTask = ref.putFile(
        photo,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading photo: $e');
      return null;
    }
  }

  Future<String?> uploadMomentPhoto(
    String userId,
    String babyId,
    File photo,
  ) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = _storage
          .ref()
          .child('users')
          .child(userId)
          .child('babies')
          .child(babyId)
          .child('moments')
          .child('$timestamp.jpg');

      final uploadTask = ref.putFile(
        photo,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading moment photo: $e');
      return null;
    }
  }

  Future<bool> deletePhoto(String photoUrl) async {
    try {
      final ref = _storage.refFromURL(photoUrl);
      await ref.delete();
      return true;
    } catch (e) {
      print('Error deleting photo: $e');
      return false;
    }
  }
}
