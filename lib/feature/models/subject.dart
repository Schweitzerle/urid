import 'package:urid/feature/models/taskAssigningService.dart';
import '../widgets/agencyQuestionnaire/agencyQuestionnaire.dart';

class Subject {
  final String uuid;
  final TaskAssigningService taskAssigningService;
  AgencyQuestionnaire? coverTaskQuestionnaire;
  AgencyQuestionnaire? buttonTaskQuestionnaire;
  AgencyQuestionnaire? flipTaskQuestionnaire;
  AgencyQuestionnaire? volumeTaskQuestionnaire;
  String? audioFilePath;
  String? consentPdfPath;

  Subject(
      this.coverTaskQuestionnaire,
      this.buttonTaskQuestionnaire,
      this.flipTaskQuestionnaire,
      this.volumeTaskQuestionnaire,
      this.audioFilePath, this.consentPdfPath, {
        required this.uuid,
        required this.taskAssigningService,
      });
}
