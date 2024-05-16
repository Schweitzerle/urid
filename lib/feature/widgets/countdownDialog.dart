import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
}

class _CountdownDialogState extends State<CountdownDialog> {
  late int _currentCountdown;

  @override
  void initState() {
    super.initState();
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
          Lottie.asset('assets/animations/study3.json'),
          SizedBox(height: 14,),
          Text('Nächste Task in $_currentCountdown Sekunden...'),
        ],
      ),
    );
  }
}
