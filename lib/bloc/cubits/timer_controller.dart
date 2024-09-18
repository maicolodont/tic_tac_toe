import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerController extends Cubit<int> {
  /// Segundos establecidos por el usuario para el contador.
  final int seconds;
  /// Se llama cuando el temporizador llega a 0.
  final void Function()? callBack;
  final bool autoReset;
  StreamSubscription<void>? _timer;

  TimerController({
    required this.seconds,
    this.autoReset = false,
    this.callBack
  }) : super(seconds) {
    _updateTimer();
  }
  
  void _updateTimer() {
    _timer = Stream<void>.periodic(const Duration(seconds: 1)).listen((_) {
      int newTime =  state - 1;

      if (newTime == -1) {
        if (callBack != null) callBack!();
        if (autoReset) reset();
      }
      //  Evitar la llamada, ya que reset() tiene notifyListeners.
      if (newTime != -1) {
        emit(newTime);
      }
    });
  }

   /// Inicia un nuevo timer.
  void starOver() {
    _timer?.resume();
    emit(seconds);
  }

  void pause() => _timer?.pause();

  void reset() => emit(seconds);

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}