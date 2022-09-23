import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'timer_model.dart';

class CountDownTimer {
  double _radius = 1;
  bool _isActive = false;
  late Timer timer;
  late Duration _time;
  late Duration _fullTime;

  late int work = 30;
  late int shortBreak = 5;
  late int longBreak = 20;

  void startWork() {
    readSettings();
    _radius = 1;
    _time = Duration(minutes: work);
    _fullTime = _time;
  }

  void startBreak({required bool isShort}) {
    readSettings();
    _radius = 1;
    _time = Duration(minutes: (isShort) ? shortBreak : longBreak);
    _fullTime = _time;
  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(
      const Duration(seconds: 1),
      (int a) {
        // this is what runs at each return event.
        String time;
        if (_isActive) {
          _time = _time - const Duration(seconds: 1);
          _radius = _time.inSeconds / _fullTime.inSeconds;
          if (_time.inSeconds <= 0) {
            _isActive = false;
          }
        }
        time = returnTime(_time);
        return TimerModel(time, _radius);
      },
    );
  }

  String returnTime(Duration t) {
    String minutes =
        (t.inMinutes < 10) ? '0${t.inMinutes}' : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds = (numSeconds < 10) ? '0$numSeconds' : numSeconds.toString();
    String formattedTime = '$minutes:$seconds';
    return formattedTime;
  }

  void stopTimer() {
    _isActive = false;
  }

  void startTimer() {
    if (_time.inSeconds > 0) {
      _isActive = true;
    }
  }

  void readSettings() async {
    var prefs = await SharedPreferences.getInstance();
    work = prefs.getInt('workTime') ?? 30;
    shortBreak = prefs.getInt('shortBreak') ?? 5;
    longBreak = prefs.getInt('longBreak') ?? 20;
  }
}
