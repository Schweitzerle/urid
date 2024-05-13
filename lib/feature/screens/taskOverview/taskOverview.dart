import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urid/feature/models/gestureTaskItem.dart';
import 'package:urid/feature/screens/TaskScreens/ButtonTaskID/buttonTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/CoverTaskID/coverTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/FingerprintTaskID/fingerprintTaskIDScreen.dart';
import 'package:urid/feature/screens/TaskScreens/FlipTaskID/flipTaskIDScreen.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';

class TaskOverviewScreen extends StatefulWidget {
  const TaskOverviewScreen({super.key});

  @override
  State<TaskOverviewScreen> createState() => _TaskOverviewScreenState();
}

class _TaskOverviewScreenState extends State<TaskOverviewScreen> {
  List<GestureTaskItem> items = [
    GestureTaskItem(
      title: 'Bildschirm Abdecken',
      icon: Icons.front_hand_rounded,
      screen: CoverTaskIDIntro(),
    ),
    GestureTaskItem(
      title: 'Button gedrückt halten',
      icon: Icons.radio_button_checked,
      screen: ButtonTaskIDIntro(),
    ),
    GestureTaskItem(
      title: 'Flip Smartphone',
      icon: Icons.flip,
      screen: FlipTaskIDIntro(),
    ),
    GestureTaskItem(
      title: 'Fingerabdruck',
      icon: Icons.fingerprint,
      screen: FingerprintTaskIDIntro(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool allItemsCompleted = items.every((item) => item.completed);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Übersicht'),
      ),
      floatingActionButton: allItemsCompleted
          ? FloatingActionButton(onPressed: () {})
          : null,
      body: CustomWillPopScopeWidget(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              onLongPress: () {
                setState(() {
                  item.completed = false;
                });
              },
              onTap: () {
                //TODO: Nicht vergessen hier wieder zu enablen, nur zu testzwecke deaktiviert
                //if (!item.completed) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => item.screen),
                  ).then((value) {
                    setState(() {
                      item.completed = true;
                    });
                  });
                }
              //},

              //TODO: Nicht vergessen hier wieder zu enablen, nur zu testzwecke deaktiviert
              //enabled: !item.completed,
            );
          },
        ),
      ),
    );
  }
}
