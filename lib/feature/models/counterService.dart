import 'package:get_it/get_it.dart';

class CounterService {
  int _counter = 0;

  int get counter => _counter;

  void incrementCounter() {
    _counter++;
  }

  void resetCounter() {
    _counter = 0;
  }
}

