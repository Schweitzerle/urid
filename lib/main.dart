import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:urid/feature/models/subject.dart';
import 'package:urid/feature/models/taskAssigningService.dart';
import 'feature/models/counterService.dart';
import 'feature/screens/introScreen/introScreen.dart';

Future<void> main() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  WidgetsFlutterBinding.ensureInitialized();
  Intl.systemLocale = await findSystemLocale();
  GetIt.I.registerSingleton<CounterService>(CounterService());
  GetIt.I.registerSingleton<TaskAssigningService>(TaskAssigningService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UUID',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9C004B)),
        useMaterial3: true,
      ),
      home: const IntroScreen(),
    );
  }

}

