import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/data/models/player.dart';

sealed class GameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Cuando un jugador realiza una jugada.
final class Play extends GameEvent {
  Play(this.player, this.position);
  final Player player;
  /// La posicion en la cuadricula.
  final Offset position;
}

final class ChangecurrentPlayer extends GameEvent {}

final class WinningPlayer extends GameEvent {
  WinningPlayer({required this.player, required this.positionsWithCombinations});
  final Player player;
  /// Los indices de los mach cuando un jugador gana.
  final List<Offset> positionsWithCombinations;
}

final class NewGame extends GameEvent {}