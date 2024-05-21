import 'package:shared_preferences/shared_preferences.dart';

class TaskAssigningService {
  static const _taskKey = 'taskKey';
  int _task = 0;

  TaskAssigningService() {
    _loadTaskFromPrefs();
  }

  int get task => _task;

  Future<void> _loadTaskFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _task = prefs.getInt(_taskKey) ?? 0;
  }

  Future<void> incrementCounter() async {
    if (_task >= 4) {
      await resetCounter();
    } else {
      _task++;
      await _saveTaskToPrefs();
    }
  }

  Future<void> resetCounter() async {
    _task = 1;
    await _saveTaskToPrefs();
  }

  Future<void> _saveTaskToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_taskKey, _task);
  }
}
