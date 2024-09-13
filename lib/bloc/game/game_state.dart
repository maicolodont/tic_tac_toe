import 'package:equatable/equatable.dart';
import 'package:tic_tac_toe/data/models/player.dart';

class GameState extends Equatable {
  GameState({
    required List<Player> players,
    required this.currentlyPlaying,
    this.winningPlayer,
    this.indexesWithMach,
    List<String>? grid,
    List<Map<Player, int>>? winners,
  }) : 
    assert(players.length == 2, "Game, can only have 2 players"),
    assert(players[0].type != players[1].type, "There cannot be two identical players, example: player 1 type X == a player 2 type X"),
    
    players = List.unmodifiable(players),

    grid = grid ?? const [
      '','','',
      '','','',
      '','',''
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
  final List<int>? indexesWithMach;
  final List<String> grid;
  /// El estado de la Grid de forma predeterminada (Vacia).
  List<String> get gridDfault => List.unmodifiable([
    '','','',
    '','','',
    '','',''
  ]);

  /// Retorna un mapa que contiene como `clave` un `Player` y un valor
  /// de la victorias.
  final List<Map<Player, int>> winners;

  GameState copyWith({
    Player? currentlyPlaying,
    Player? winningPlayer,
    List<String>? grid,
    List<int>? indexesWithMach,
    List<Map<Player, int>>? winners,
  }) {
    return GameState(
      players: players,
      currentlyPlaying: currentlyPlaying ?? this.currentlyPlaying,
      winningPlayer: winningPlayer,
      grid: grid ?? this.grid,
      indexesWithMach: indexesWithMach,
      winners: winners ?? this.winners
    );
  }
  
  @override
  List<Object?> get props => [
    players, 
    currentlyPlaying, 
    winningPlayer, 
    grid,
    indexesWithMach,
    winners
  ];
}