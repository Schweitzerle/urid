import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
      barrierColor: Color(0xff1f0407),
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

class _CountdownDialogState extends State<CountdownDialog> with SingleTickerProviderStateMixin {
  late int _currentCountdown;
  final TaskAssigningService taskAssigningService = GetIt.instance<TaskAssigningService>();
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    print(taskAssigningService.task);
    _currentCountdown = widget.countdownSeconds;
    _startCountdown();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    _animationController.forward();
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: AlertDialog(
        title: const Text('Pause', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 14),
            Text('$_currentCountdown Sekunden...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.center,),
            SizedBox(height: 24),
            Text('...bis zur nächsten Task'),
          ],
        ),
      ),
    );
  }
}
