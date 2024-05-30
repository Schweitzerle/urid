import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../models/strings.dart';

class EndScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/thanks.json',
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        Strings.endScreenThankYouTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40),
                      Text(
                        Strings.endScreenThankYouBody,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
