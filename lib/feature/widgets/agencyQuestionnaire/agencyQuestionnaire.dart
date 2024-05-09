import 'package:flutter/cupertino.dart';

class AgencyQuestionnaire {
  final TaskType taskType;
  int movementAgencyQuestionValue;
  int agencyQuestionValue;
  int controlFeelingViewChangeQuestionValue;

  AgencyQuestionnaire({
    required this.taskType,
    required this.movementAgencyQuestionValue,
    required this.agencyQuestionValue,
    required this.controlFeelingViewChangeQuestionValue,
  });
}

enum TaskType {
coverPhone,
holdButton,
flipPhone,
fingerprint
}

extension ParseToString on TaskType {
  String toNiceString() {
    switch (this) {
      case TaskType.coverPhone:
        return "Bildschirm abdecken";
      case TaskType.holdButton:
        return "Button gedrückt halten";
      case TaskType.flipPhone:
        return "Flip Smartphone";
      case TaskType.fingerprint:
        return "Fingerabdruck";
      default: return "Konnte Tasktype nicht identifizieren..";
    }
  }
}