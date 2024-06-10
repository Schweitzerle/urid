import 'dart:async';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get_it/get_it.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:urid/feature/models/subject.dart';
import 'package:urid/feature/screens/EndScreen/endScreen.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';
import 'package:urid/feature/models/taskTimer.dart';

import '../../models/strings.dart';

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
  String csvFilePath = '';
  final subject = GetIt.instance<Subject>();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _createCsvFile();
  }

  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _recordDuration += Duration(seconds: 1);
      });
    });
  }

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
      _recordDuration = Duration.zero;
    });

    _startTimer();
  }

  Future<void> _stopRecording() async {
    String? path = await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
      _audioFilePath = path;
    });

    _recorderSubscription?.cancel();
    _timer?.cancel();
  }

  void _deleteRecording() {
    if (_audioFilePath != null) {
      File(_audioFilePath!).delete();
    }
    setState(() {
      _audioFilePath = null;
      _recordDuration = Duration.zero;
    });
  }

  Future<void> _createCsvFile() async {
    List<List<dynamic>> rows = [
      [
        "UUID",
        "Task",
        "CoverTask_Movement",
        "CoverTask_Agency",
        "CoverTask_ControlFeeling",
        "ButtonTask_Movement",
        "ButtonTask_Agency",
        "ButtonTask_ControlFeeling",
        "FlipTask_Movement",
        "FlipTask_Agency",
        "FlipTask_ControlFeeling",
        "VolumeTask_Movement",
        "VolumeTask_Agency",
        "VolumeTask_ControlFeeling"
      ],
      [
        subject.uuid,
        subject.taskAssigningService.task,
        subject.coverTaskQuestionnaire?.movementAgencyQuestionValue ?? "",
        subject.coverTaskQuestionnaire?.agencyQuestionValue ?? "",
        subject.coverTaskQuestionnaire?.controlFeelingViewChangeQuestionValue ?? "",
        subject.buttonTaskQuestionnaire?.movementAgencyQuestionValue ?? "",
        subject.buttonTaskQuestionnaire?.agencyQuestionValue ?? "",
        subject.buttonTaskQuestionnaire?.controlFeelingViewChangeQuestionValue ?? "",
        subject.flipTaskQuestionnaire?.movementAgencyQuestionValue ?? "",
        subject.flipTaskQuestionnaire?.agencyQuestionValue ?? "",
        subject.flipTaskQuestionnaire?.controlFeelingViewChangeQuestionValue ?? "",
        subject.volumeTaskQuestionnaire?.movementAgencyQuestionValue ?? "",
        subject.volumeTaskQuestionnaire?.agencyQuestionValue ?? "",
        subject.volumeTaskQuestionnaire?.controlFeelingViewChangeQuestionValue ?? ""
      ]
    ];

    rows.addAll(taskTimer.getCsvRows());

    String csvData = const ListToCsvConverter().convert(rows);
    Directory tempDir = await getTemporaryDirectory();
    setState(() {
      csvFilePath = '${tempDir.path}/subject_data.csv';
    });
    File csvFile = File(csvFilePath);
    await csvFile.writeAsString(csvData);
  }

  Future<void> _sendEmail(RoundedLoadingButtonController controller) async {
    final pdfFilePath = subject.consentPdfPath;

    final List<File> attachments = [];
    if (_audioFilePath != null) {
      attachments.add(File(_audioFilePath!));
    }
    attachments.add(File(csvFilePath));
    if (pdfFilePath != null) {
      attachments.add(File(pdfFilePath));
    }

    final smtpServer = gmail('julianschweizer9@gmail.com', Strings.googleAppPassword);

    final message = Message()
      ..from = Address('julianschweizer9@gmail.com', 'Julian Schweizer')
      ..recipients.add('julianschweizer9@gmail.com')
      ..subject = 'Interview Data'
      ..text = 'Subject CSV-Daten und Audio File von Studie von Proband ${subject.uuid} und Taskreihenfolge ${subject.taskAssigningService.task}.'
      ..attachments.addAll(attachments.map((file) => FileAttachment(file)));

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      controller.success();
      await Future.delayed(Duration(seconds: 2));
      _navigateToNextScreen();
    } on MailerException catch (e) {
      print('Message not sent. \n${e.toString()}');
      controller.error();
      await Future.delayed(Duration(seconds: 2));
      controller.reset();
    }
  }

  void _navigateToNextScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EndScreen()));
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
          centerTitle: true,
          title: Text(Strings.interviewTitle),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(child: child, opacity: animation);
                  },
                  child: _isRecording
                      ? Column(
                    key: ValueKey<int>(1),
                    children: [
                      Text(
                        Strings.recordingInProgress,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        durationText,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  )
                      : _audioFilePath != null
                      ? Column(
                    children: [
                      Card(
                        key: ValueKey<int>(2),
                        elevation: 4,
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
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                        child: ListTile(
                          leading: Icon(Icons.description,
                              color: Colors.green),
                          title: Text(
                            Strings.csvFileResults,
                            style: TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                csvFilePath,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                        child: ListTile(
                          leading: Icon(Icons.picture_as_pdf_outlined,
                              color: Colors.red),
                          title: Text(
                            Strings.consentFormPdf,
                            style: TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                subject.consentPdfPath!,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    key: ValueKey<int>(3),
                    children: [
                      Text(
                        Strings.noRecordingAvailable,
                        style: TextStyle(
                            fontSize: 16, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                IconButton(
                  iconSize: 64.0,
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: _isRecording ? Colors.red : Colors.black,
                  ),
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                ),
                SizedBox(height: 20),
                if (!_isRecording && _audioFilePath != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _deleteRecording,
                          icon: Icon(Icons.delete, color: Colors.white),
                          label: Text(
                            Strings.deleteRecording,
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: RoundedLoadingButton(
                          controller: _btnController,
                          onPressed: () => _sendEmail(_btnController),
                          successColor: Colors.green,
                          errorColor: Colors.red,
                          child: Wrap(
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                Strings.sendData,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
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
