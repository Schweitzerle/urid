import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:csv/csv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:urid/feature/models/subject.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';
import '../../models/strings.dart';
import '../../models/taskTimer.dart';
import '../EndScreen/endScreen.dart';

class DataSendingScreen extends StatefulWidget {
  @override
  _DataSendingScreenState createState() => _DataSendingScreenState();
}

class _DataSendingScreenState extends State<DataSendingScreen> {
  String csvFilePath = '';
  final subject = GetIt.instance<Subject>();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final TaskTimer taskTimer = GetIt.instance.get<TaskTimer>();

  @override
  void initState() {
    super.initState();
    _createCsvFile();
  }

  Future<void> _createCsvFile() async {
    List<List<dynamic>> rows = [
      [
        "UUID",
        "Task",
        "CoverTask_MovementControl",
        "CoverTask_ControlFeeling",
        "CoverTask_ControlFeelingViewChange",
        "CoverTask_TaskAwareness",
        "CoverTask_InteractionFeedback",
        "CoverTask_DataPrivacy",
        "CoverTask_ControlOverSharedContent",
        "ButtonTask_MovementControl",
        "ButtonTask_ControlFeeling",
        "ButtonTask_ControlFeelingViewChange",
        "ButtonTask_TaskAwareness",
        "ButtonTask_InteractionFeedback",
        "ButtonTask_DataPrivacy",
        "ButtonTask_ControlOverSharedContent",
        "FlipTask_MovementControl",
        "FlipTask_ControlFeeling",
        "FlipTask_ControlFeelingViewChange",
        "FlipTask_TaskAwareness",
        "FlipTask_InteractionFeedback",
        "FlipTask_DataPrivacy",
        "FlipTask_ControlOverSharedContent",
        "VolumeTask_MovementControl",
        "VolumeTask_ControlFeeling",
        "VolumeTask_ControlFeelingViewChange",
        "VolumeTask_TaskAwareness",
        "VolumeTask_InteractionFeedback",
        "VolumeTask_DataPrivacy",
        "VolumeTask_ControlOverSharedContent",
        "",
        "",
        "DemoQuest_Age",
        "DemoQuest_PassUsage",
        "DemoQuest_Smartphone",
        "DemoQuest_Status",
        "DemoQuest_WalletUsage",
        "DemoQuest_WalletUsageExtend",
        "",
        "",
        "Button-1", "Button-2", "Button-3",
        "Cover-1", "Cover-2", "Cover-3",
        "Flip-1", "Flip-2", "Flip-3",
        "Volume-1", "Volume-2", "Volume-3",
      ],
      [
        subject.uuid,
        subject.taskAssigningService.task,
        subject.coverTaskQuestionnaire?.movementControlQuestionValue ?? "",
        subject.coverTaskQuestionnaire?.controlFeelingQuestionValue ?? "",
        subject.coverTaskQuestionnaire?.controlFeelingViewChangeQuestionValue ?? "",
        subject.coverTaskQuestionnaire?.taskAwarenessQuestionValue ?? "",
        subject.coverTaskQuestionnaire?.interactionFeedbackQuestionValue ?? "",
        subject.coverTaskQuestionnaire?.dataPrivacyQuestionValue ?? "",
        subject.coverTaskQuestionnaire?.controlOverSharedContentQuestionValue ?? "",
        subject.buttonTaskQuestionnaire?.movementControlQuestionValue ?? "",
        subject.buttonTaskQuestionnaire?.controlFeelingQuestionValue ?? "",
        subject.buttonTaskQuestionnaire?.controlFeelingViewChangeQuestionValue ?? "",
        subject.buttonTaskQuestionnaire?.taskAwarenessQuestionValue ?? "",
        subject.buttonTaskQuestionnaire?.interactionFeedbackQuestionValue ?? "",
        subject.buttonTaskQuestionnaire?.dataPrivacyQuestionValue ?? "",
        subject.buttonTaskQuestionnaire?.controlOverSharedContentQuestionValue ?? "",
        subject.flipTaskQuestionnaire?.movementControlQuestionValue ?? "",
        subject.flipTaskQuestionnaire?.controlFeelingQuestionValue ?? "",
        subject.flipTaskQuestionnaire?.controlFeelingViewChangeQuestionValue ?? "",
        subject.flipTaskQuestionnaire?.taskAwarenessQuestionValue ?? "",
        subject.flipTaskQuestionnaire?.interactionFeedbackQuestionValue ?? "",
        subject.flipTaskQuestionnaire?.dataPrivacyQuestionValue ?? "",
        subject.flipTaskQuestionnaire?.controlOverSharedContentQuestionValue ?? "",
        subject.volumeTaskQuestionnaire?.movementControlQuestionValue ?? "",
        subject.volumeTaskQuestionnaire?.controlFeelingQuestionValue ?? "",
        subject.volumeTaskQuestionnaire?.controlFeelingViewChangeQuestionValue ?? "",
        subject.volumeTaskQuestionnaire?.taskAwarenessQuestionValue ?? "",
        subject.volumeTaskQuestionnaire?.interactionFeedbackQuestionValue ?? "",
        subject.volumeTaskQuestionnaire?.dataPrivacyQuestionValue ?? "",
        subject.volumeTaskQuestionnaire?.controlOverSharedContentQuestionValue ?? "",
        "",
        "",
        subject.demographicQuestionnaire?.age ?? "",
        subject.demographicQuestionnaire?.digitalPassUsage ?? "",
        subject.demographicQuestionnaire?.smartphone ?? "",
        subject.demographicQuestionnaire?.status ?? "",
        subject.demographicQuestionnaire?.walletUsage ?? "",
        subject.demographicQuestionnaire?.walletUsageExtend ?? "",
        "",
        "",
        taskTimer.getTaskDuration('Button', 0).inMilliseconds.toString() + "ms",
        taskTimer.getTaskDuration('Button', 1).inMilliseconds.toString() + "ms",
        taskTimer.getTaskDuration('Button', 2).inMilliseconds.toString() + "ms",
        taskTimer.getTaskDuration('Cover', 0).inMilliseconds.toString() + "ms",
        taskTimer.getTaskDuration('Cover', 1).inMilliseconds.toString() + "ms",
        taskTimer.getTaskDuration('Cover', 2).inMilliseconds.toString() + "ms",
        taskTimer.getTaskDuration('Flip', 0).inMilliseconds.toString() + "ms",
        taskTimer.getTaskDuration('Flip', 1).inMilliseconds.toString() + "ms",
        taskTimer.getTaskDuration('Flip', 2).inMilliseconds.toString() + "ms",
        taskTimer.getTaskDuration('Volume', 0).inMilliseconds.toString() + "ms",
        taskTimer.getTaskDuration('Volume', 1).inMilliseconds.toString() + "ms",
        taskTimer.getTaskDuration('Volume', 2).inMilliseconds.toString() + "ms",
      ]
    ];

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
    if (subject.audioFilePath != null) {
      attachments.add(File(subject.audioFilePath!));
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
      _navigateToEndScreen();
    } on MailerException catch (e) {
      print('Message not sent. \n${e.toString()}');
      controller.error();
      await Future.delayed(Duration(seconds: 2));
      controller.reset();
    }
  }

  void _navigateToEndScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EndScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Datenversand"),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: CustomWillPopScopeWidget(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          subject.audioFilePath!,
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
                RoundedLoadingButton(
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
              ],
            )
          ),
        ),
      ),
    );
  }
}
