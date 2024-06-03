import 'package:crypto_tracker/ui/my_app.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart' as models;
import 'package:watch_it/watch_it.dart';
import 'data/currency_repository/currency_repository.dart';
import 'di/injections.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();


  runApp(const App());
}






