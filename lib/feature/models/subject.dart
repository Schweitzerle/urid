import 'package:urid/feature/models/taskAssigningService.dart';
import '../widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
import '../widgets/demograficQuestionnaire/demograficQuestionnaire.dart';

//Klasse, welche den Probanden repräsentiert und die gesammelten Daten rund um seine Studie
class Subject {
  final String uuid;
  final TaskAssigningService taskAssigningService;
  AgencyQuestionnaire? coverTaskQuestionnaire;
  AgencyQuestionnaire? buttonTaskQuestionnaire;
  AgencyQuestionnaire? flipTaskQuestionnaire;
  AgencyQuestionnaire? volumeTaskQuestionnaire;
  String? audioFilePath;
  String? consentPdfPath;
  String? csvFilePath;
  DemographicQuestionnaire? demographicQuestionnaire;


  Subject(
      this.coverTaskQuestionnaire,
      this.buttonTaskQuestionnaire,
      this.flipTaskQuestionnaire,
      this.volumeTaskQuestionnaire,
      this.audioFilePath, this.consentPdfPath,
      this.demographicQuestionnaire,
      this.csvFilePath,
      {
        required this.uuid,
        required this.taskAssigningService,
      });
}
