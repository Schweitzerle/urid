import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfSignatureScreen extends StatefulWidget {
  @override
  _PdfSignatureScreenState createState() => _PdfSignatureScreenState();
}

class _PdfSignatureScreenState extends State<PdfSignatureScreen> {
  final _sign = GlobalKey<SignatureState>();
  Uint8List? _pdfData;
  String? _pdfPath;
  final GlobalKey _signatureCanvasKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final ByteData data = await DefaultAssetBundle.of(context).load("assets/pdf/consent.pdf");
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/Einwilligungserklaerung_HuiWa.pdf');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    setState(() {
      _pdfData = data.buffer.asUint8List();
      _pdfPath = tempFile.path;
    });
  }

  Future<void> _savePdf() async {
    RenderRepaintBoundary boundary = _signatureCanvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image signatureImage = await boundary.toImage();
    ByteData? byteData = await signatureImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List imageUint8List = byteData!.buffer.asUint8List();

    final document = pw.Document();
    final originalPdf = pw.MemoryImage(_pdfData!);
    final signature = pw.MemoryImage(imageUint8List);

    document.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Stack(
          children: [
            pw.Image(originalPdf),
            pw.Positioned(
              left: 100,
              bottom: 50,
              child: pw.Image(signature, width: 200, height: 50),
            ),
          ],
        ),
      ),
    );

    final output = await document.save();
    final outputFile = File('${(await getTemporaryDirectory()).path}/signed_document.pdf');
    await outputFile.writeAsBytes(output);

    OpenFile.open(outputFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einverständniserklärung'),
      ),
      body: Column(
        children: [
          if (_pdfPath != null)
            Expanded(
              child: RepaintBoundary(
                key: _signatureCanvasKey,
                child: Stack(
                  children: [
                    PDFView(
                      filePath: _pdfPath!,
                    ),
                    Signature(
                      key: _sign,
                      color: Colors.black,
                      strokeWidth: 5.0,
                      backgroundPainter: null,
                    ),
                  ],
                ),
              ),
            )
          else
            Center(child: CircularProgressIndicator()),
          ElevatedButton(
            onPressed: _savePdf,
            child: Text('Speichern'),
          ),
        ],
      ),
    );
  }
}
