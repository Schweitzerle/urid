import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urid_api_client/urid_api_client.dart';

class PassWidgetProvider extends StatelessWidget {
  final URIDPass pass;

  const PassWidgetProvider({required this.pass, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.verified, color: Theme.of(context).colorScheme.onPrimary),
      title: Text(
        "${"Ausgestellt am"} ${DateFormat.yMMMEd().format(pass.createdAt)} ${'von'} ${pass.providerDepartment.get()} (${pass.providerFacility.get()}).",
        style: DefaultTextStyle.of(context)
            .style
            .copyWith(color: Theme.of(context).colorScheme.onPrimary, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
