// MIT License

// Copyright (c) [2024] [maicolodont.dev]

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

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