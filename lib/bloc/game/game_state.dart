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

class GameState extends Equatable {
  GameState({
    required List<Player> players,
    required this.currentlyPlaying,
    this.winningPlayer,
    this.positionsWithCombinations,
    List<List<String>>? grid,
    List<Map<Player, int>>? winners,
  }) : 
    assert(players.length == 2, "Game, can only have 2 players"),
    assert(players[0].type != players[1].type, "There cannot be two identical players, example: player 1 type X == a player 2 type X"),
    
    players = List.unmodifiable(players),

    grid = grid ?? const [
      ['', '',''],
      ['', '',''],
      ['', '',''],
    ],

    // Iniciamos los jugadores con 0 victorias si no hay ganadores.
    winners = winners ?? [
      {players[0]: 0},
      {players[1]: 0}
    ];

  final List<Player> players;
  /// Player en turno.
  final Player currentlyPlaying;
  /// El player que acaba de ganar.
  final Player? winningPlayer;
  /// Los indices de los mach cuando un jugador gana.
  final List<Offset>? positionsWithCombinations;
  final List<List<String>> grid;
  /// El estado de la Grid de forma predeterminada (Vacia).
  List<List<String>> get gridDfault => List.unmodifiable([
    ['', '',''],
    ['', '',''],
    ['', '',''],
  ]);

  /// Retorna un mapa que contiene como `clave` un `Player` y un valor
  /// de la victorias.
  final List<Map<Player, int>> winners;

  GameState copyWith({
    Player? currentlyPlaying,
    Player? winningPlayer,
    List<List<String>>? grid,
    List<Offset>? positionsWithCombinations,
    List<Map<Player, int>>? winners,
  }) {
    return GameState(
      players: players,
      currentlyPlaying: currentlyPlaying ?? this.currentlyPlaying,
      winningPlayer: winningPlayer,
      grid: grid ?? this.grid,
      positionsWithCombinations: positionsWithCombinations,
      winners: winners ?? this.winners
    );
  }
  
  @override
  List<Object?> get props => [
    players, 
    currentlyPlaying, 
    winningPlayer, 
    grid,
    positionsWithCombinations,
    winners
  ];
}