import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urid/feature/models/subject.dart';
import 'package:urid/feature/screens/demographicQuestionnaireScreen/demographicSurveyScreen.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';
import 'package:urid/feature/models/taskTimer.dart';

import '../../models/strings.dart';

//Auf diesem Screen wird das Interview durchgeführt
class AudioRecorderScreen extends StatefulWidget {
  @override
  _AudioRecorderScreenState createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final TaskTimer taskTimer = GetIt.instance.get<TaskTimer>();
  bool _isRecording = false;
  String? _audioFilePath;
  StreamSubscription? _recorderSubscription;
  Duration _recordDuration = Duration.zero;
  Timer? _timer;
  final subject = GetIt.instance<Subject>();
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  String pdfPath = '';
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _loadPdf();
    _showDialog();
  }

  //Mikrofon Berechtigung checken und Recorder initialisieren
  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  //PDF Interviewleitfaden auf dem Bildschirm darstellen
  Future<void> _loadPdf() async {
    try {
      final ByteData bytes =
          await rootBundle.load('assets/pdf/Interviewleitfaden.pdf');
      final Uint8List list = bytes.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/Interviewleitfaden.pdf');
      await file.writeAsBytes(list);
      setState(() {
        pdfPath = file.path;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading PDF: $e';
      });
    }
  }

  //Timer starten zur UI-Verbesserung um zu sehen wie lange das Interview schon geht
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _recordDuration += Duration(seconds: 1);
      });
    });
  }

  //Recording starten
  Future<void> _startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/audio_record.aac';
    await _recorder.startRecorder(toFile: path);

    _recorderSubscription = _recorder.onProgress!.listen((e) {
      setState(() {
        _recordDuration = e.duration;
      });
    });

    setState(() {
      _isRecording = true;
      _audioFilePath = null;
      subject.audioFilePath = null;
      _recordDuration = Duration.zero;
    });

    _startTimer();
  }

  //Recording stoppen
  Future<void> _stopRecording() async {
    String? path = await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
      _audioFilePath = path;
      subject.audioFilePath = path;
    });

    _recorderSubscription?.cancel();
    _timer?.cancel();
  }

  //Audio löschen
  void _deleteRecording() {
    if (_audioFilePath != null) {
      File(_audioFilePath!).delete();
    }
    setState(() {
      _audioFilePath = null;
      subject.audioFilePath = null;
      _recordDuration = Duration.zero;
    });
  }

  void _navigateToNextScreen() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DemographicSurveyScreen()));
  }

  //Dialog zur Aufforderung das Smartphone dem Versuchsleiter zurückzugeben
  Future<void> _showDialog() async {
    await Future.delayed(Duration.zero);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hinweis"),
          content: Text(
              "Sie können das Smartphone nun wieder dem Versuchsleiter geben."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _recorderSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String durationText = _formatDuration(_recordDuration);
    return CustomWillPopScopeWidget(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(Strings.interviewTitle),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(child: child, opacity: animation);
                      },
                      child: _audioFilePath != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  key: ValueKey<int>(2),
                                  elevation: 8,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 25),
                                  child: ListTile(
                                    leading: Icon(Icons.audiotrack,
                                        color: Colors.blue),
                                    title: Text(
                                      Strings.recordedAudioFile,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _audioFilePath!,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Länge: $durationText',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                if (!_isRecording && _audioFilePath != null)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: _deleteRecording,
                                          icon: Icon(Icons.delete,
                                              color: Colors.white),
                                          label: Text(
                                            Strings.deleteRecording,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              _navigateToNextScreen(),
                                          child: Wrap(
                                            children: [
                                              Text(Strings.next),
                                              SizedBox(width: 8),
                                              Icon(Icons.navigate_next),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            )
                          : Stack(
                              key: ValueKey<int>(1),
                              children: [
                                Positioned.fill(
                                  child: pdfPath.isNotEmpty
                                      ? PDFView(
                                          filePath: pdfPath,
                                          enableSwipe: true,
                                          swipeHorizontal: false,
                                          autoSpacing: false,
                                          pageFling: true,
                                          pageSnap: true,
                                          defaultPage: currentPage!,
                                          fitPolicy: FitPolicy.BOTH,
                                          preventLinkNavigation: false,
                                          onRender: (_pages) {
                                            setState(() {
                                              pages = _pages;
                                              isReady = true;
                                            });
                                          },
                                          onError: (error) {
                                            setState(() {
                                              errorMessage = error.toString();
                                            });
                                          },
                                          onPageError: (page, error) {
                                            setState(() {
                                              errorMessage =
                                                  '$page: ${error.toString()}';
                                            });
                                          },
                                          onViewCreated: (PDFViewController
                                              pdfViewController) {
                                            _controller
                                                .complete(pdfViewController);
                                          },
                                          onLinkHandler: (String? uri) {
                                            print('goto uri: $uri');
                                          },
                                          onPageChanged:
                                              (int? page, int? total) {
                                            setState(() {
                                              currentPage = page;
                                            });
                                          },
                                        )
                                      : Center(
                                          child: CircularProgressIndicator()),
                                ),
                                Positioned(
                                  bottom: 20,
                                  right: 20,
                                  child: Material(
                                    elevation: 8.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: FittedBox(
                                              child: Text(
                                                _isRecording
                                                    ? durationText
                                                    : Strings
                                                        .noRecordingAvailable,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: IconButton(
                                              icon: Icon(
                                                size: 50,
                                                _isRecording
                                                    ? Icons.stop
                                                    : Icons.mic,
                                                color: _isRecording
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                              onPressed: _isRecording
                                                  ? _stopRecording
                                                  : _startRecording,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
