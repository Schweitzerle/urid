import 'package:flutter/material.dart';
import '../models/strings.dart';

//Klasse um versehentliches Auslösen des System-Zurück Buttons zu vermeiden und davor einen Bestätigungsdialog anzuzeigen
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
      title: Text(Strings.exitConfirmationTitle),
      content: Text(Strings.exitConfirmationContent),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(Strings.no),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(Strings.yes),
        ),
      ],
    );
  }
}
