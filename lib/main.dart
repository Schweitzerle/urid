import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:urid/feature/models/taskAssigningService.dart';
import 'package:urid/feature/screens/IntroScreen/introScreen.dart';
import 'package:urid/feature/widgets/signaturePDF.dart';
import 'feature/models/counterService.dart';
import 'feature/models/taskTimer.dart';


//TODO: Videos neu aufnehmen, sind im Moment noch mit den vertauschten Ansichten
Future<void> main() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  Intl.systemLocale = await findSystemLocale();
  GetIt.I.registerSingleton<CounterService>(CounterService());
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9C004B)),
        useMaterial3: true,
      ),
      home: const IntroScreen(),
    );
  }

}

