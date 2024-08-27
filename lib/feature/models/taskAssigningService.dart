import 'package:shared_preferences/shared_preferences.dart';

//Klasse um die Latin Square Einteilung der verschiedenen Taskreihenfolgen zuzuweisen
class TaskAssigningService {
  static const _taskKey = 'taskKey';
  int _task = 0;

  TaskAssigningService() {
    _loadTaskFromPrefs();
  }

  int get task => _task;

  //Taskzuweisung von shared preferences laden
  Future<void> _loadTaskFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _task = prefs.getInt(_taskKey) ?? 0;
  }

  //Taskzuweisung erhöhen solange die Taskzuweisung kleiner gleich vier ist, da es nur vier Tasks sind
  Future<void> incrementCounter() async {
    if (_task >= 4) {
      await resetCounter();
    } else {
      _task++;
      await _saveTaskToPrefs();
    }
  }

  //Taskzuweisung auf die erste Taskreihenfolge setzten
  Future<void> resetCounter() async {
    _task = 1;
    await _saveTaskToPrefs();
  }

  //Taskzuweisung in shared preferences speichern
  Future<void> _saveTaskToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_taskKey, _task);
  }
}
