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