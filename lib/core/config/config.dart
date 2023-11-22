import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ucc_quiz_portal/firebase_options.dart';

/// Configures the app dependencies
Future<void> configureApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
}
