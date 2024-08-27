//Klasse um interne Daten zu sammeln, ob Gesten einen unerwartete Hohe Taskperfomarncezeit haben, nur für Debugging Zwecke bestimmt
class TaskTimer {
  final Map<String, List<Duration>> _taskDurations = {};

  void startTask(String taskName, int repeatIndex) {
    if (!_taskDurations.containsKey(taskName)) {
      _taskDurations[taskName] = List.filled(3, Duration.zero, growable: false);
    }
    if (_isValidIndex(taskName, repeatIndex)) {
      _taskDurations[taskName]![repeatIndex] = Duration.zero;
    }
  }

  void endTask(String taskName, int repeatIndex, Duration duration) {
    if (_isValidIndex(taskName, repeatIndex)) {
      _taskDurations[taskName]![repeatIndex] = duration;
    }
  }

  Duration getTaskDuration(String taskName, int repeatIndex) {
    if (_isValidIndex(taskName, repeatIndex)) {
      return _taskDurations[taskName]![repeatIndex];
    }
    return Duration.zero;
  }

  List<Duration> getTaskDurations(String taskName) {
    if (_taskDurations.containsKey(taskName)) {
      return _taskDurations[taskName]!;
    }
    return [];
  }

  Map<String, List<Duration>> getAllTaskDurations() {
    return _taskDurations;
  }

  Duration getTotalDuration() {
    return _taskDurations.values.expand((durations) => durations).reduce((a, b) => a + b);
  }

  bool _isValidIndex(String taskName, int repeatIndex) {
    return _taskDurations.containsKey(taskName) && repeatIndex >= 0 && repeatIndex < 3;
  }
}
