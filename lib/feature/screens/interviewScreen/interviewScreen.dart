import 'dart:async';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urid/feature/models/subject.dart';
import 'package:urid/feature/models/taskAssigningService.dart';

class AudioRecorderScreen extends StatefulWidget {
  @override
  _AudioRecorderScreenState createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _audioFilePath;
  StreamSubscription? _recorderSubscription;
  Duration _recordDuration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
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
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
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

  Future<void> _sendEmail() async {
    final subject = GetIt.instance<Subject>();

    // Generate CSV data
    List<List<dynamic>> rows = [
      ["UUID", "Task", "CoverTask_Movement", "CoverTask_Agency", "CoverTask_ControlFeeling",
        "ButtonTask_Movement", "ButtonTask_Agency", "ButtonTask_ControlFeeling",
        "FlipTask_Movement", "FlipTask_Agency", "FlipTask_ControlFeeling",
        "VolumeTask_Movement", "VolumeTask_Agency", "VolumeTask_ControlFeeling"],
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

    String csvData = const ListToCsvConverter().convert(rows);
    Directory tempDir = await getTemporaryDirectory();
    String csvFilePath = '${tempDir.path}/subject_data.csv';
    File csvFile = File(csvFilePath);
    await csvFile.writeAsString(csvData);

    final Email email = Email(
      body: 'Here is the audio file and subject data from the interview.',
      subject: 'Interview Data',
      recipients: ['example@example.com'],
      attachmentPaths: [_audioFilePath!, csvFilePath],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('Error sending email: $error');
    }
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
    String durationText = _recordDuration.toString().split('.').first.padLeft(8, "0");

    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isRecording)
              Text('Recording: $durationText', style: TextStyle(fontSize: 20)),
            if (!_isRecording && _audioFilePath != null)
              Text('Recorded file: $_audioFilePath', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            IconButton(
              iconSize: 64.0,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              onPressed: _isRecording ? _stopRecording : _startRecording,
            ),
            SizedBox(height: 20),
            if (!_isRecording && _audioFilePath != null)
              ElevatedButton(
                onPressed: _deleteRecording,
                child: Text('Delete Recording'),
              ),
            if (!_isRecording && _audioFilePath != null)
              ElevatedButton(
                onPressed: _sendEmail,
                child: Text('Send Email'),
              ),
            if (!_isRecording && _audioFilePath == null)
              Text('No recording available', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
