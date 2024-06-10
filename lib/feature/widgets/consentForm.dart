import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:urid/feature/screens/ErrorScreen/errorScreen.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';
import 'dart:io';
import '../models/subject.dart';
import '../models/taskAssigningService.dart';
import '../screens/TaskScreens/ButtonTaskID/buttonTaskIDScreen.dart';
import '../screens/TaskScreens/CoverTaskID/coverTaskIDScreen.dart';
import '../screens/TaskScreens/FlipTaskID/flipTaskIDScreen.dart';
import '../screens/TaskScreens/VolumeButtonTaskID/volumeButtonTaskIDScreen.dart';
import '../models/strings.dart';

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
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(14),
          title: Container(
            padding: EdgeInsets.all(14),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  Strings.drawYourSignature,
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
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
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
                      child: const Text(Strings.clear),
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
                      child: const Text(Strings.save),
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
      '${Strings.consentTitle}\n\n${Strings.consentDescription}\n\n${Strings.dateLabel} $formattedDate\n\n${Strings.signatureLabel}',
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
          title: Text(Strings.confirmationTitle),
          content: Text(Strings.confirmationContent, textAlign: TextAlign.justify,),
          actions: <Widget>[
            TextButton(
              child: Text(Strings.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(Strings.yes),
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
                        return ErrorScreen();
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
      appBar: AppBar(title: Text(Strings.consentTitle,), backgroundColor: Theme.of(context).colorScheme.primaryContainer,),
      body: CustomWillPopScopeWidget(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              titleWidget: Container(),
              bodyWidget: const Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        Strings.consentInfo1Title,
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        Strings.consentInfo1Description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
              decoration: const PageDecoration(
                bodyAlignment: Alignment.center,
              ),
            ),
            PageViewModel(
              titleWidget: Container(),
              bodyWidget: const Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        Strings.consentInfo2Title,
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        Strings.consentInfo2Description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
              decoration: const PageDecoration(
                bodyAlignment: Alignment.center,
              ),
            ),
            PageViewModel(
              titleWidget: Container(),
              bodyWidget: const Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        Strings.consentInfo3Title,
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        Strings.consentInfo3Description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
              decoration: const PageDecoration(
                bodyAlignment: Alignment.center,
              ),
            ),
            PageViewModel(
              titleWidget: Container(),
              bodyWidget: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.consentTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        Strings.consentDescription,
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${Strings.dateLabel} $formattedDate',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        Strings.signatureLabel,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                              Strings.tapToSign,
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
              ),
              decoration: PageDecoration(
                titlePadding: EdgeInsets.zero
              )
            ),
          ],
          onDone: _saveConsentPDFAndNavigateNext,
          showSkipButton: false,
          showNextButton: true,
          next: const Icon(Icons.arrow_forward),
          done: const Text(Strings.finished, style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
