import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:urid_api_client/urid_api_client.dart';

import '../pass.dart';


class PassWidgetCover extends StatelessWidget {
  final URIDPass pass;

  const PassWidgetCover({required this.pass, super.key});

  static Widget createImageForPass(URIDPass pass) {
    var image = Image.memory(base64Decode(pass.properties["photo"]!.value));
    return CircleAvatar(backgroundImage: image.image, radius: 96);
  }

  static Widget createValidationLabel(URIDPass pass, BuildContext context) {
    if (pass.isValid) {
      return Center(
        child: Text(
          "${"Dieser Ausweis ist gültig bis zum"} . ${"Die Gültigkeit kann über diesen QR-Code geprüft werden."}",
          textAlign: TextAlign.center,
        ),
      );
    }
    return Center(
      child: Text("${"Die Gültigkeit dieses Ausweises konnte nicht geprüft werden."}."),
    );
  }

  static Widget createValidationCode(URIDPass pass) {
    if (pass.isValid) {
      return QrImageView(
        // TODO Create validation url on server side before sending pass to client
        data: "https:/id.uni-regensburg.de/api/v1/validate/${pass.id}",
        version: QrVersions.auto,
        size: 160.0,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid && pass.properties["smartID"] != null) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InteractiveViewer(
            maxScale: 3.0,
            minScale: 0.5,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Theme.of(context).primaryColor,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                PassWidgetHeader(pass: pass),
                const SizedBox(
                  height: 8,
                ),
                PassWidgetProvider(pass: pass),
                const SizedBox(
                  height: 8,
                ),
                PassWidgetOwner(pass: pass),
                const SizedBox(
                  height: 8,
                ),
                PassWidgetPropertiesCover(pass: pass),
                const SizedBox(
                  height: 8,
                ),
                PassWidgetValidation(pass: pass),
              ]),
            ),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InteractiveViewer(
          maxScale: 3.0,
          minScale: 0.5,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Theme.of(context).primaryColor,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              PassWidgetHeader(pass: pass),
              const SizedBox(
                height: 8,
              ),
              PassWidgetProvider(pass: pass),
              const SizedBox(
                height: 8,
              ),
              PassWidgetOwner(pass: pass),
              const SizedBox(
                height: 8,
              ),
              PassWidgetPropertiesCover(pass: pass),
              const SizedBox(
                height: 8,
              ),
              PassWidgetValidation(pass: pass),
            ]),
          ),
        ),
      ),
    );
  }
}
