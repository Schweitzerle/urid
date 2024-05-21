import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

import '../models/taskAssigningService.dart';

class CountdownDialog extends StatefulWidget {
  final int countdownSeconds;
  final Function onCountdownComplete;

  const CountdownDialog({
    Key? key,
    required this.countdownSeconds,
    required this.onCountdownComplete,
  }) : super(key: key);

  @override
  _CountdownDialogState createState() => _CountdownDialogState();

  static Future<void> showCountdownDialog(BuildContext context, int countdownSeconds, Function onCountdownComplete) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CountdownDialog(
          countdownSeconds: countdownSeconds,
          onCountdownComplete: onCountdownComplete,
        );
      },
    );
  }
}

class _CountdownDialogState extends State<CountdownDialog> {
  late int _currentCountdown;
  final TaskAssigningService taskAssigningService = GetIt.instance<TaskAssigningService>();


  @override
  void initState() {
    super.initState();
    print(taskAssigningService.task);
    _currentCountdown = widget.countdownSeconds;
    _startCountdown();
  }

  void _startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentCountdown == 0) {
        timer.cancel();
        widget.onCountdownComplete();
      } else {
        setState(() {
          _currentCountdown--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pause'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/animations/break.json'),
          SizedBox(height: 14,),
          Text('Nächste Task in $_currentCountdown Sekunden...'),
        ],
      ),
    );
  }
}
