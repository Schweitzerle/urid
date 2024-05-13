import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class FingerprintAuthenticationDialog extends StatefulWidget {
  final Function(bool success) onAuthenticated;

  const FingerprintAuthenticationDialog({Key? key, required this.onAuthenticated}) : super(key: key);

  @override
  _FingerprintAuthenticationDialogState createState() => _FingerprintAuthenticationDialogState();
}

class _FingerprintAuthenticationDialogState extends State<FingerprintAuthenticationDialog> {
  bool _authenticating = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            child: Text(
              'Fingerabdruck-Authentifizierung',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Scanne deinen Fingerabdruck um dich zu authentifizieren',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          GestureDetector(
            onLongPress: () => _startFingerprintAuthentication(context),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _authenticating ? Colors.green : Theme.of(context).colorScheme.inverseSurface,
              ),
              child: _authenticating
                  ? Icon(Icons.check, size: 80, color: Colors.white)
                  : Icon(Icons.fingerprint, size: 80, color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Halte den Fingerabdruck-Button gedrückt',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomLeft,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // Schließe das Bottom Sheet
              },
              child: Text(
                'Abbrechen',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startFingerprintAuthentication(BuildContext context) {
    Vibration.vibrate(
      pattern: [300, 400, 300, 400, 300, 400],
      intensities: [2, 4, 2, 4, 2, 4],
    );
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _authenticating = true;
      });
      Vibration.vibrate(
        pattern: [300],
        intensities: [100],
      );
    });
    _completeAuthentication();
  }

  void _completeAuthentication() {
    Future.delayed(Duration(seconds: 2), () {
      widget.onAuthenticated(true);
      Vibration.cancel();
      Navigator.pop(context);
    });
  }
}

void showFingerprintBottomSheet(BuildContext context, Function(bool success) onAuthenticated) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return FingerprintAuthenticationDialog(
        onAuthenticated: onAuthenticated,
      );
    },
  );
}
