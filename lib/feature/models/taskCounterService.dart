class TaskCounterService {
  //Klasse um darzustellen bei welcher Task der Proband sich gerade befindet
  int _taskCounter = 1;

  int get taskCounter => _taskCounter;

  void incrementCounter() {
    _taskCounter++;
  }

  void resetCounter() {
    _taskCounter = 1;
  }
}