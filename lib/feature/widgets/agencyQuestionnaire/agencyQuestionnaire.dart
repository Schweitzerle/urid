import 'package:flutter/cupertino.dart';
import '../../models/strings.dart';

class AgencyQuestionnaire {
  final TaskType taskType;
  int movementControlQuestionValue;
  int controlFeelingQuestionValue;
  int controlFeelingViewChangeQuestionValue;
  int taskAwarenessQuestionValue;
  int interactionFeedbackQuestionValue;
  int dataPrivacyQuestionValue;
  int controlOverSharedContentQuestionValue;

  AgencyQuestionnaire({
    required this.taskType,
    required this.movementControlQuestionValue,
    required this.controlFeelingQuestionValue,
    required this.controlFeelingViewChangeQuestionValue,
    required this.taskAwarenessQuestionValue,
    required this.interactionFeedbackQuestionValue,
    required this.dataPrivacyQuestionValue,
    required this.controlOverSharedContentQuestionValue,
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
        return Strings.coverPhone;
      case TaskType.holdButton:
        return Strings.holdButton;
      case TaskType.flipPhone:
        return Strings.flipPhone;
      case TaskType.volumeButton:
        return Strings.volumeButton;
      default:
        return Strings.unidentifiedTaskType;
    }
  }
}
