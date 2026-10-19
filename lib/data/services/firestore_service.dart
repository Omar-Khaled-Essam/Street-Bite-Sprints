import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

/// Singleton Pattern: one Firestore façade is used app-wide.
/// When Firebase is not configured, it falls back to SharedPreferences so
/// the rest of the architecture stays the same.
class FirestoreService {
  FirestoreService._({
    required SharedPreferences prefs,
    required bool firebaseEnabled,
  }) : _prefs = prefs,
       _firebaseEnabled = firebaseEnabled,
       _firestore = firebaseEnabled ? FirebaseFirestore.instance : null;

  static FirestoreService? _instance;

  factory FirestoreService() {
    final instance = _instance;
    if (instance == null) {
      throw StateError('FirestoreService has not been initialized');
    }
    return instance;
  }

  static FirestoreService initialize({
    required SharedPreferences prefs,
    required bool firebaseEnabled,
  }) {
    _instance = FirestoreService._(
      prefs: prefs,
      firebaseEnabled: firebaseEnabled,
    );
    return _instance!;
  }

  final SharedPreferences _prefs;
  final bool _firebaseEnabled;
  final FirebaseFirestore? _firestore;
  final _orderController = StreamController<List<OrderModel>>.broadcast();
  final _favController = StreamController<List<String>>.broadcast();

  Future<void> upsertUser(UserModel user) async {
    if (_firebaseEnabled) {
      await _firestore!.collection('users').doc(user.id).set(user.toJson());
      return;
    }
    await _prefs.setString('user_${user.id}', jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser(String userId) async {
    if (_firebaseEnabled) {
      final snap = await _firestore!.collection('users').doc(userId).get();
      final data = snap.data();
      if (data == null) return null;
      return UserModel.fromJson(data);
    }
    final raw = _prefs.getString('user_$userId');
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Stream<List<String>> watchFavourites(String userId) {
    if (_firebaseEnabled) {
      return _firestore!
          .collection('users')
          .doc(userId)
          .snapshots()
          .map((snap) {
            final data = snap.data();
            final list = data?['favourites'] as List<dynamic>? ?? [];
            return list.map((e) => e.toString()).toList();
          });
    }
    Future.microtask(() => _favController.add(_readFavourites(userId)));
    return _favController.stream;
  }

  Future<void> toggleFavourite(String userId, String mealId) async {
    if (_firebaseEnabled) {
      final ref = _firestore!.collection('users').doc(userId);
      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(ref);
        final current =
            (snap.data()?['favourites'] as List<dynamic>? ?? [])
                .map((e) => e.toString())
                .toList();
        if (current.contains(mealId)) {
          current.remove(mealId);
        } else {
          current.add(mealId);
        }
        tx.set(ref, {'favourites': current}, SetOptions(merge: true));
      });
      return;
    }
    final current = _readFavourites(userId);
    if (current.contains(mealId)) {
      current.remove(mealId);
    } else {
      current.add(mealId);
    }
    await _prefs.setString(
      '${AppConstants.localFavouritesKey}_$userId',
      jsonEncode(current),
    );
    _favController.add(current);
  }

  List<String> _readFavourites(String userId) {
    final raw = _prefs.getString('${AppConstants.localFavouritesKey}_$userId');
    if (raw == null) return [];
    return (jsonDecode(raw) as List<dynamic>).map((e) => e.toString()).toList();
  }

  Future<void> saveOrder(OrderModel order) async {
    if (_firebaseEnabled) {
      await _firestore!.collection('orders').doc(order.id).set(order.toJson());
      return;
    }
    final all = _readOrders().where((o) => o.id != order.id).toList()
      ..add(order);
    await _prefs.setString(
      AppConstants.localOrdersKey,
      jsonEncode(all.map((e) => e.toJson()).toList()),
    );
    _orderController.add(all.where((o) => o.userId == order.userId).toList());
  }

  Stream<List<OrderModel>> watchOrders(String userId) {
    if (_firebaseEnabled) {
      return _firestore!
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map(
            (snap) =>
                snap.docs.map((d) => OrderModel.fromJson(d.data())).toList()
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
          );
    }
    Future.microtask(
      () => _orderController.add(
        _readOrders().where((o) => o.userId == userId).toList(),
      ),
    );
    return _orderController.stream.map(
      (orders) => orders.where((o) => o.userId == userId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    );
  }

  List<OrderModel> _readOrders() {
    final raw = _prefs.getString(AppConstants.localOrdersKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List<dynamic>)
        .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
