//getiT für klassenübergreifenden zugriff auf Probanden Objekt. Dort wird dann alles zu ID und Fragebögen gespeichert und am ende in CSV Konvertiert und an Email geschickt
import '../widgets/agencyQuestionnaire/agencyQuestionnaire.dart';
//TODO: id als uuid mit postfix von dem taskassigningservice.task also der task zuweisungsnummer

class Subject {
  final int id;
  final AgencyQuestionnaire? coverTaskQuestionnaire;
  final AgencyQuestionnaire? buttonTaskQuestionnaire;
  final AgencyQuestionnaire? flipTaskQuestionnaire;
  final AgencyQuestionnaire? fingerprintTaskQuestionnaire;

  Subject({required this.id, this.coverTaskQuestionnaire, this.buttonTaskQuestionnaire, this.flipTaskQuestionnaire, this.fingerprintTaskQuestionnaire, });

}