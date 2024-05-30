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

class _CountdownDialogState extends State<CountdownDialog> with SingleTickerProviderStateMixin {
  late int _currentCountdown;
  final TaskAssigningService taskAssigningService = GetIt.instance<TaskAssigningService>();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    print(taskAssigningService.task);
    _currentCountdown = widget.countdownSeconds;
    _startCountdown();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

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
    return SlideTransition(
      position: _slideAnimation,
      child: AlertDialog(
        title: Text('Pause'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/animations/break.json'),
            SizedBox(height: 14),
            Text('Nächste Task in $_currentCountdown Sekunden...'),
          ],
        ),
      ),
    );
  }
}
