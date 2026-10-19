import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var firebaseEnabled = false;
  if (DefaultFirebaseOptions.isConfigured) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      firebaseEnabled = true;
    } catch (_) {
      firebaseEnabled = false;
    }
  }
  await configureDependencies(firebaseEnabled: firebaseEnabled);
  runApp(const StreetBiteApp());
}
