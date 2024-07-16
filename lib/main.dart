import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:urid/feature/models/taskAssigningService.dart';
import 'package:urid/feature/models/taskCounterService.dart';
import 'package:urid/feature/screens/IntroScreen/introScreen.dart';
import 'feature/models/counterService.dart';
import 'feature/models/taskTimer.dart';


Future<void> main() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  Intl.systemLocale = await findSystemLocale();
  GetIt.I.registerSingleton<CounterService>(CounterService());
  GetIt.I.registerSingleton<TaskCounterService>(TaskCounterService());
  GetIt.I.registerSingleton<TaskAssigningService>(TaskAssigningService());
  GetIt.I.registerSingleton<TaskTimer>(TaskTimer());
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF000000)),
        useMaterial3: true,
      ),
      home: const IntroScreen(),
    );
  }

}

