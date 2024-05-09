import 'package:flutter/material.dart';

class CustomWillPopScopeWidget extends StatelessWidget {
  final Widget child;

  CustomWillPopScopeWidget({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: child,
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await _showExitDialog(context);
    return exitResult ?? false;
  }

  Future<bool?> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Bitte bestätige!'),
      content: const Text('Willst du den Vorgang wirklich beenden? Bitte konsultiere zerst den Versuchsleiter!'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Nein'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Ja'),
        ),
      ],
    );
  }

}
