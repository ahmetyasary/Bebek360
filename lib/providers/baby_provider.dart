import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../models/baby.dart';
import '../models/feeding.dart';
import '../models/diaper.dart';
import '../models/sleep.dart';
import '../models/growth.dart';
import '../models/moment.dart';
import '../models/vaccine.dart';
import '../services/photo_service.dart';

class BabyProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Baby> _babies = [];
  Baby? _selectedBaby;

  List<Baby> get babies => _babies;
  Baby? get selectedBaby => _selectedBaby;

  void selectBaby(String? babyId) {
    if (babyId == null) {
      _selectedBaby = null;
    } else {
      _selectedBaby = _babies.firstWhere((baby) => baby.id == babyId);
    }
    notifyListeners();
  }

  Future<void> loadBabies(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .get();

    _babies = await Future.wait(
      querySnapshot.docs.map((doc) async {
        final baby = Baby.fromMap({...doc.data(), 'id': doc.id});
        await Future.wait([
          _loadFeedings(userId, baby),
          _loadDiapers(userId, baby),
          _loadSleeps(userId, baby),
          _loadGrowthMeasurements(userId, baby),
          _loadMoments(userId, baby),
          _loadVaccines(userId, baby),
        ]);
        return baby;
      }),
    );

    if (_babies.isNotEmpty && _selectedBaby == null) {
      _selectedBaby = _babies.first;
    }

    notifyListeners();
  }

  Future<void> addBaby(
      String userId, String name, DateTime birthDate, File? photo) async {
    final docRef =
        _firestore.collection('users').doc(userId).collection('babies').doc();
    final baby = Baby(
      id: docRef.id,
      name: name,
      birthDate: birthDate,
    );

    String? photoUrl;
    if (photo != null) {
      photoUrl =
          await PhotoService.instance.uploadBabyPhoto(userId, docRef.id, photo);
    }

    final babyWithPhoto = baby.copyWith(photoUrl: photoUrl);
    await docRef.set(babyWithPhoto.toMap());
    _babies.add(babyWithPhoto);
    notifyListeners();
  }

  Future<void> updateBaby(String userId, Baby baby) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(baby.id)
        .update(baby.toMap());

    final index = _babies.indexWhere((b) => b.id == baby.id);
    if (index != -1) {
      _babies[index] = baby;
      if (_selectedBaby?.id == baby.id) {
        _selectedBaby = baby;
      }
      notifyListeners();
    }
  }

  Future<void> deleteBaby(String userId, String babyId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(babyId)
        .delete();

    _babies.removeWhere((baby) => baby.id == babyId);
    if (_selectedBaby?.id == babyId) {
      _selectedBaby = _babies.isNotEmpty ? _babies.first : null;
    }
    notifyListeners();
  }

  Future<void> _loadFeedings(String userId, Baby baby) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(baby.id)
        .collection('feedings')
        .orderBy('startTime', descending: true)
        .get();

    final feedings = querySnapshot.docs
        .map((doc) => Feeding.fromMap({...doc.data(), 'id': doc.id}))
        .toList();

    _updateBaby(baby.copyWith(feedings: feedings));
  }

  Future<void> _loadDiapers(String userId, Baby baby) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(baby.id)
        .collection('diapers')
        .orderBy('time', descending: true)
        .get();

    final diapers = querySnapshot.docs
        .map((doc) => Diaper.fromMap({...doc.data(), 'id': doc.id}))
        .toList();

    _updateBaby(baby.copyWith(diapers: diapers));
  }

  Future<void> _loadSleeps(String userId, Baby baby) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(baby.id)
        .collection('sleeps')
        .orderBy('startTime', descending: true)
        .get();

    final sleeps = querySnapshot.docs
        .map((doc) => Sleep.fromMap({...doc.data(), 'id': doc.id}))
        .toList();

    _updateBaby(baby.copyWith(sleeps: sleeps));
  }

  Future<void> _loadGrowthMeasurements(String userId, Baby baby) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(baby.id)
        .collection('growth')
        .orderBy('date', descending: true)
        .get();

    final growthMeasurements = querySnapshot.docs
        .map((doc) => Growth.fromMap({...doc.data(), 'id': doc.id}))
        .toList();

    _updateBaby(baby.copyWith(growthMeasurements: growthMeasurements));
  }

  Future<void> _loadMoments(String userId, Baby baby) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(baby.id)
        .collection('moments')
        .orderBy('timestamp', descending: true)
        .get();

    final moments = querySnapshot.docs
        .map((doc) => Moment.fromMap({...doc.data(), 'id': doc.id}))
        .toList();

    _updateBaby(baby.copyWith(moments: moments));
  }

  Future<void> _loadVaccines(String userId, Baby baby) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(baby.id)
        .collection('vaccines')
        .orderBy('date')
        .get();

    final vaccines = querySnapshot.docs
        .map((doc) => Vaccine.fromMap({...doc.data(), 'id': doc.id}))
        .toList();

    _updateBaby(baby.copyWith(vaccines: vaccines));
  }

  Future<void> addVaccine(
    String userId,
    String babyId,
    String name,
    DateTime date, {
    String? note,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(babyId)
        .collection('vaccines')
        .doc();

    final vaccine = Vaccine(
      id: docRef.id,
      babyId: babyId,
      name: name,
      date: date,
      note: note,
    );

    await docRef.set(vaccine.toMap());

    final baby = _babies.firstWhere((b) => b.id == babyId);
    final updatedVaccines = [...baby.vaccines, vaccine];
    _updateBaby(baby.copyWith(vaccines: updatedVaccines));
  }

  Future<void> updateVaccine(
    String userId,
    String babyId,
    Vaccine vaccine,
  ) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(babyId)
        .collection('vaccines')
        .doc(vaccine.id);

    await docRef.update(vaccine.toMap());

    final baby = _babies.firstWhere((b) => b.id == babyId);
    final updatedVaccines = baby.vaccines.map((v) {
      return v.id == vaccine.id ? vaccine : v;
    }).toList();
    _updateBaby(baby.copyWith(vaccines: updatedVaccines));
  }

  Future<void> deleteVaccine(
    String userId,
    String babyId,
    String vaccineId,
  ) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(babyId)
        .collection('vaccines')
        .doc(vaccineId);

    await docRef.delete();

    final baby = _babies.firstWhere((b) => b.id == babyId);
    final updatedVaccines =
        baby.vaccines.where((v) => v.id != vaccineId).toList();
    _updateBaby(baby.copyWith(vaccines: updatedVaccines));
  }

  void _updateBaby(Baby baby) {
    final index = _babies.indexWhere((b) => b.id == baby.id);
    if (index != -1) {
      _babies[index] = baby;
      if (_selectedBaby?.id == baby.id) {
        _selectedBaby = baby;
      }
      notifyListeners();
    }
  }

  Future<void> addFeeding(
    String userId,
    String babyId,
    DateTime startTime,
    FeedingType type, {
    DateTime? endTime,
    double? amount,
    String? note,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(babyId)
        .collection('feedings')
        .doc();

    final feeding = Feeding(
      id: docRef.id,
      babyId: babyId,
      startTime: startTime,
      endTime: endTime,
      type: type,
      amount: amount,
      note: note,
    );

    await docRef.set(feeding.toMap());

    final baby = _babies.firstWhere((b) => b.id == babyId);
    final updatedFeedings = [...baby.feedings, feeding];
    _updateBaby(baby.copyWith(feedings: updatedFeedings));
  }

  Future<void> addDiaper(
    String userId,
    String babyId,
    DateTime time,
    DiaperType type, {
    String? note,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(babyId)
        .collection('diapers')
        .doc();

    final diaper = Diaper(
      id: docRef.id,
      babyId: babyId,
      time: time,
      type: type,
      note: note,
    );

    await docRef.set(diaper.toMap());

    final baby = _babies.firstWhere((b) => b.id == babyId);
    final updatedDiapers = [...baby.diapers, diaper];
    _updateBaby(baby.copyWith(diapers: updatedDiapers));
  }

  Future<void> addSleep(
    String userId,
    String babyId,
    DateTime startTime, {
    DateTime? endTime,
    String? note,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(babyId)
        .collection('sleeps')
        .doc();

    final sleep = Sleep(
      id: docRef.id,
      babyId: babyId,
      startTime: startTime,
      endTime: endTime,
      note: note,
    );

    await docRef.set(sleep.toMap());

    final baby = _babies.firstWhere((b) => b.id == babyId);
    final updatedSleeps = [...baby.sleeps, sleep];
    _updateBaby(baby.copyWith(sleeps: updatedSleeps));
  }

  Future<void> addGrowth(
    String userId,
    String babyId,
    DateTime date, {
    double? weight,
    double? height,
    double? headCircumference,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(babyId)
        .collection('growth')
        .doc();

    final growth = Growth(
      id: docRef.id,
      babyId: babyId,
      date: date,
      weight: weight,
      height: height,
      headCircumference: headCircumference,
    );

    await docRef.set(growth.toMap());

    final baby = _babies.firstWhere((b) => b.id == babyId);
    final updatedGrowth = [...baby.growthMeasurements, growth];
    _updateBaby(baby.copyWith(growthMeasurements: updatedGrowth));
  }

  Future<void> updateBabyPhoto(
      String userId, String babyId, String photoUrl) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(babyId);

    await docRef.update({'photoUrl': photoUrl});

    final baby = _babies.firstWhere((b) => b.id == babyId);
    _updateBaby(baby.copyWith(photoUrl: photoUrl));
  }

  Future<void> addMoment(
    String userId,
    String babyId,
    String photoUrl, {
    String? note,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(babyId)
        .collection('moments')
        .doc();

    final moment = Moment(
      id: docRef.id,
      babyId: babyId,
      photoUrl: photoUrl,
      note: note,
      timestamp: DateTime.now(),
    );

    await docRef.set(moment.toMap());

    final baby = _babies.firstWhere((b) => b.id == babyId);
    final updatedMoments = [...baby.moments, moment];
    _updateBaby(baby.copyWith(moments: updatedMoments));
  }

  Future<void> deleteMoment(
      String userId, String babyId, String momentId) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('babies')
        .doc(babyId)
        .collection('moments')
        .doc(momentId);

    await docRef.delete();

    final baby = _babies.firstWhere((b) => b.id == babyId);
    final updatedMoments = baby.moments.where((m) => m.id != momentId).toList();
    _updateBaby(baby.copyWith(moments: updatedMoments));
  }
}
