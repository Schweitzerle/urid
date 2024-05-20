import 'package:get_it/get_it.dart';

class TaskAssigningService {
  //TODO: wieder auf eins setzten, nur für testzwecke
  //TODO: SharedPrefs um state of task nummer sitzungsübergreifend zu merken und somit automoatisch neue probanden nach latinsquare reihenfolge einteilen. incrementtask soll am besten erst vor der ersten task, also am ende vom introscreen (vermeidet fehler, wenn man die app mal aus versheen startet, dann wird dort nicht die task nummer erhöht und verzerrt die latinsquare reihenfolge)
  int _task = 4;

  int get task => _task;

  void incrementCounter() {
    if (_task >= 4) {
      resetCounter();
    }
    _task++;
  }

  void resetCounter() {
    _task = 1;
  }
}
