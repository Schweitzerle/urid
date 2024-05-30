import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:urid_api_client/urid_api_client.dart';
import 'package:urid/feature/screens/TaskScreens/ButtonTaskID/pass_properties_button.dart';
import 'package:urid/feature/screens/TaskScreens/FlipTaskID/pass_properties_flip.dart';
import 'package:urid/feature/screens/TaskScreens/CoverTaskID/pass_properties_cover.dart';
import 'package:urid/feature/screens/TaskScreens/VolumeButtonTaskID/pass_properties_volume_button.dart';
import 'package:urid/feature/widgets/pass/pass.dart';

enum PassType {
  button,
  flip,
  cover,
  volume,
}

class PassWidget extends StatelessWidget {
  final URIDPass pass;
  final bool showHiddenProperties;
  final PassType passType;

  PassWidget({
    required this.pass,
    required this.showHiddenProperties,
    required this.passType,
    super.key,
  });

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
      child: Text(
          "Die Gültigkeit dieses Ausweises konnte nicht geprüft werden."),
    );
  }

  static Widget createValidationCode(URIDPass pass) {
    if (pass.isValid) {
      return QrImageView(
        data: "https:/id.uni-regensburg.de/api/v1/validate/${pass.id}",
        version: QrVersions.auto,
        size: 160.0,
      );
    }
    return Container();
  }

  Widget _buildPassProperties() {
    switch (passType) {
      case PassType.button:
        return PassWidgetPropertiesButton(
            pass: pass, showHiddenProperties: showHiddenProperties);
      case PassType.flip:
        return PassWidgetPropertiesFlip(
            pass: pass, showHiddenProperties: showHiddenProperties);
      case PassType.cover:
        return PassWidgetPropertiesCover(pass: pass);
      case PassType.volume:
        return PassWidgetPropertiesVolumeButton(
            pass: pass, showHiddenProperties: showHiddenProperties);
      default:
        return Container();
    }
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
              color: Theme
                  .of(context)
                  .primaryColor,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                PassWidgetHeader(pass: pass),
                const SizedBox(height: 8),
                PassWidgetProvider(pass: pass),
                const SizedBox(height: 8),
                PassWidgetOwner(pass: pass),
                const SizedBox(height: 8),
                _buildPassProperties(),
                const SizedBox(height: 8),
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
            color: Theme
                .of(context)
                .primaryColor,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              PassWidgetHeader(pass: pass),
              const SizedBox(height: 8),
              PassWidgetProvider(pass: pass),
              const SizedBox(height: 8),
              PassWidgetOwner(pass: pass),
              const SizedBox(height: 8),
              _buildPassProperties(),
              const SizedBox(height: 8),
              PassWidgetValidation(pass: pass),
            ]),
          ),
        ),
      ),
    );
  }
}
