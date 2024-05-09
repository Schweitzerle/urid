import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urid_api_client/urid_api_client.dart';

class PassWidgetOwner extends StatelessWidget {
  final URIDPass pass;

  const PassWidgetOwner({required this.pass, super.key});

  static Widget createImageForPass(URIDPass pass) {
    if (pass.properties["photo"] != null && pass.properties["photo"]!.value != "") {
      var image = Image.memory(
        base64Decode(pass.properties["photo"]!.value),
        height: 96,
        width: 96,
      );
      return ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(10.0)), child: image);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          createImageForPass(pass),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pass.hasProperty("fullname") ? pass.getProperty("fullname")!.value : "",
                  style: DefaultTextStyle.of(context).style.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
              Text(pass.hasProperty("facility") ? pass.getProperty("facility")!.value : "",
                  style: DefaultTextStyle.of(context).style.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
              Text(pass.hasProperty("organizationalUnit") ? pass.getProperty("organizationalUnit")!.value : "",
                  style: DefaultTextStyle.of(context).style.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}
