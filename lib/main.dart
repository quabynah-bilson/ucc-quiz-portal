import 'package:flutter/material.dart';
import 'package:ucc_quiz_portal/core/app.dart';
import 'package:ucc_quiz_portal/core/config/config.dart';

/// sample credentials
///
/// username: ps/itc/21/0051
/// password: <request from app developer>
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureApp();
  runApp(const UccQuizPortal());
}
