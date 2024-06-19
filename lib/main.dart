import 'package:crypto_tracker/ui/my_app.dart';
import 'package:flutter/material.dart';
import 'di/injections.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const App());
}






