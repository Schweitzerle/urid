class TaskCounterService {
  int _taskCounter = 1;

  int get taskCounter => _taskCounter;

  void incrementCounter() {
    _taskCounter++;
  }

  void resetCounter() {
    _taskCounter = 1;
  }
}