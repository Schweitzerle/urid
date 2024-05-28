import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:urid/feature/screens/InterviewScreen/interviewScreen.dart';
import 'dart:io';

import '../models/subject.dart';
import '../models/taskAssigningService.dart';
import '../screens/EndScreen/endScreen.dart';
import '../screens/TaskScreens/ButtonTaskID/buttonTaskIDScreen.dart';
import '../screens/TaskScreens/CoverTaskID/coverTaskIDScreen.dart';
import '../screens/TaskScreens/FlipTaskID/flipTaskIDScreen.dart';
import '../screens/TaskScreens/VolumeButtonTaskID/volumeButtonTaskIDScreen.dart';

class ConsentForm extends StatefulWidget {
  @override
  _ConsentFormState createState() => _ConsentFormState();
}

class _ConsentFormState extends State<ConsentForm> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  bool _isSigned = false;
  Uint8List? _signatureData;
  final TaskAssigningService taskAssigningService = GetIt.instance<TaskAssigningService>();
  String? _pdfFilePath;
  final subject = GetIt.instance<Subject>();
  final String formattedDate = DateFormat('dd.MM.yyyy').format(DateTime.now());

  void _showSignaturePad() {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Draw your signature',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto-Medium',
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.clear,
                  color: const Color.fromRGBO(0, 0, 0, 0.54),
                  size: 24.0,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 172,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: SfSignaturePad(
                    minimumStrokeWidth: 1.0,
                    maximumStrokeWidth: 4.0,
                    strokeColor: Colors.black,
                    backgroundColor: Colors.white,
                    key: _signaturePadKey,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        _signaturePadKey.currentState!.clear();
                      },
                      child: const Text('CLEAR'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final ui.Image imageData = await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
                        final ByteData? bytes = await imageData.toByteData(format: ui.ImageByteFormat.png);
                        if (bytes != null) {
                          setState(() {
                            _signatureData = bytes.buffer.asUint8List();
                            _isSigned = true;
                          });
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('SAVE'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveConsentPDFAndNavigateNext() async {
    PdfDocument document = PdfDocument();

    final page = document.pages.add();

    page.graphics.drawString(
      'Einverständniserklärung\n\n'
          'Ich erkläre mich hiermit einverstanden, dass ich an der Studie teilnehme, bei der verschiedene Gesten an einem externen Smartphone durchgeführt werden. '
          'Im Anschluss werden Fragebögen ausgefüllt und ein Interview durchgeführt, das mit einem Mikrofon aufgezeichnet wird. '
          'Diese Einverständniserklärung gilt bis auf Widerruf. Ich habe das Recht, meine Einwilligung jederzeit zu widerrufen.\n\n'
          'Datum: $formattedDate\n\n'
          'Unterschrift:',
      PdfStandardFont(PdfFontFamily.helvetica, 18),
      bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, 400),
    );

    if (_isSigned && _signatureData != null) {
      final PdfBitmap bitmap = PdfBitmap(_signatureData!);
      page.graphics.drawImage(
        bitmap,
        Rect.fromLTWH(0, 410, 200, 100),
      );
    }

    final List<int> bytes = await document.save();
    document.dispose();

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/consent_form.pdf';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    setState(() {
      _pdfFilePath = path;
      subject.consentPdfPath = _pdfFilePath;
    });

   _navigateToNextScreen();
    print('PDF saved at: $path');
  }

  void _navigateToNextScreen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bestätigung'),
          content: Text('Möchten Sie wirklich zum nächsten Bildschirm wechseln? Gehen Sie sicher, dass Sie die Einverständniserklärung unterzeichnet haben!'),
          actions: <Widget>[
            TextButton(
              child: Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ja'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    switch (taskAssigningService.task) {
                      case 1:
                        return CoverTaskIDIntro();
                      case 2:
                        return ButtonTaskIDIntro();
                      case 3:
                        return VolumeButtonTaskIDIntro();
                      case 4:
                        return FlipTaskIDIntro();
                      default:
                        return EndScreen();
                    }
                  }),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: _isSigned && _signatureData != null
          ? FloatingActionButton(
        onPressed: _saveConsentPDFAndNavigateNext,
        child: Icon(Icons.arrow_forward),
      ) : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Einverständniserklärung',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Ich erkläre mich hiermit einverstanden, dass ich an der Studie teilnehme, bei der verschiedene Gesten an einem externen Smartphone durchgeführt werden. '
                          'Im Anschluss werden Fragebögen ausgefüllt und ein Interview durchgeführt, das mit einem Mikrofon aufgezeichnet wird. '
                          'Diese Einverständniserklärung gilt bis auf Widerruf. Ich habe das Recht, meine Einwilligung jederzeit zu widerrufen.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Datum: $formattedDate',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Unterschrift:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: _showSignaturePad,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _isSigned && _signatureData != null
                          ? Image.memory(_signatureData!)
                          : Center(
                        child: Text(
                          'Tap here to sign',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
