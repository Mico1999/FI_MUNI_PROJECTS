import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_catalog/common/widget/app_root.dart';
import 'package:movie_catalog/common/service/ioc_container.dart';
import 'package:movie_catalog/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  IoCContainer.setup();
  runApp(const AppRoot());
}
