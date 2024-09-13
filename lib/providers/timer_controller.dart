import 'dart:async';
import 'package:flutter/material.dart';

class TimerController extends ChangeNotifier {
  /// Segundos establecidos por el usuario para el contador.
  final int seconds;
  /// Se llama cuando el temporizador llega a 0.
  final void Function()? callBack;
  final bool autoReset;
  StreamSubscription<void>? _timer;
  int _remainingTime;
  /// Tiempo restante del temporizador.
  int get remainingTime => _remainingTime;

  TimerController({
   required this.seconds,
    this.autoReset = false,
    this.callBack
  }) : _remainingTime = seconds {
    _updateTimer();
  }

  void _updateTimer() {
    _timer = Stream<void>.periodic(const Duration(seconds: 1)).listen((_) {
      _remainingTime = _remainingTime - 1;

        if (_remainingTime == -1) {
        if (callBack != null) callBack!();
        if (autoReset) reset();
      }
      //  Evitar la llamada, ya que reset() tiene notifyListeners.
      if (_remainingTime != -1) notifyListeners();
    });
  }

  /// Inicia un nuevo timer.
  void starOver() {
    _remainingTime = seconds;
    _timer?.resume();
    notifyListeners();
  }

  void pause() => _timer?.pause();

  void reset() {
    _remainingTime = seconds;
    notifyListeners();
  }

  void cancel() => _timer?.cancel(); 
}