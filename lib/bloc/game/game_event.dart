import 'package:equatable/equatable.dart';
import 'package:tic_tac_toe/data/models/player.dart';

sealed class GameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Cuando un jugador realiza una jugada.
final class Play extends GameEvent {
  Play(this.player, this.indexPosition);
  final Player player;
  /// La posicion del indice en la cuadricula.
  final int indexPosition;
}

final class ChangecurrentPlayer extends GameEvent {}

final class WinningPlayer extends GameEvent {
  WinningPlayer({required this.player, required this.indexesWithMach});
  final Player player;
  /// Los indices de los mach cuando un jugador gana.
  final List<int> indexesWithMach;
}

final class NewGame extends GameEvent {}