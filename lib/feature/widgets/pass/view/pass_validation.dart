import 'package:flutter/material.dart';
import 'package:urid_api_client/urid_api_client.dart';

class PassWidgetValidation extends StatelessWidget {
  final URIDPass pass;

  const PassWidgetValidation({required this.pass, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.zero,
        topRight: Radius.zero,
        bottomRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
      ),
      child: Container(
        alignment: Alignment.center,
        color: pass.isValid ? Colors.green : Theme.of(context).colorScheme.error,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            pass.isValidDescription.get()!,
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(color: Theme.of(context).colorScheme.onPrimary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
