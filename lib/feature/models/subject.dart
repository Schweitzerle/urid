//getiT für klassenübergreifenden zugriff auf Probanden Objekt. Dort wird dann alles zu ID und Fragebögen gespeichert und am ende in CSV Konvertiert und an Email geschickt
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

  Subject(this.coverTaskQuestionnaire, this.buttonTaskQuestionnaire, this.flipTaskQuestionnaire, this.volumeTaskQuestionnaire, this.audioFilePath, {required this.uuid, required this.taskAssigningService});

}