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
volumeButton
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
      case TaskType.volumeButton:
        return "Lautstärketasten";
      default: return "Konnte Tasktype nicht identifizieren..";
    }
  }
}