import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tic_tac_toe/bloc/game/game_event.dart';
import 'package:tic_tac_toe/bloc/game/game_state.dart';
import 'package:tic_tac_toe/data/models/player.dart';
import 'package:tic_tac_toe/utils/detect_winner.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final AudioPlayer _audioButtonPress = AudioPlayer();
  final AudioPlayer _audioWinning = AudioPlayer();

  GameBloc({required List<Player> players}) : 
    super(GameState(
      players: players, 
      currentlyPlaying: players[Random().nextInt(2)])
    ) {

    on<Play>(_playEvent);
    on<ChangecurrentPlayer>(_changeCurrentPlayerEvent);
    on<WinningPlayer>(_winningPlayer);
    on<NewGame>(_newGame);
  }

  void _playEvent(Play event, Emitter<GameState> emit) {
    // Efecto al pulsar una celda.
    _audioButtonPress.setAudioSource(AudioSource.asset('assets/audios/button-press.wav'));
    _audioButtonPress.seek(Duration.zero);
    _audioButtonPress.setVolume(0.5);
    _audioButtonPress.play();

    List<String> gridUpdate = List.of( state.grid);
    gridUpdate[event.indexPosition] = event.player.type.name;
    final indexesWithMach = DetectWinner.cell9(gridUpdate);

    // Verificar si la grid esta llena (No hay un ganador) para hacer reset..
    if (gridUpdate.every((test) => test != '')) {
      add(NewGame());
      return;
    }

    // Hay un ganador.
    if (indexesWithMach != null) {
      add(WinningPlayer(player: state.currentlyPlaying, indexesWithMach: indexesWithMach));
    }
    
    emit(state.copyWith(
        grid: gridUpdate, 
        currentlyPlaying: indexesWithMach != null ? null : _changecurrentPlayer(),
      )
    );
  }

  void _changeCurrentPlayerEvent(ChangecurrentPlayer event, Emitter<GameState> emit) {
    emit(state.copyWith(currentlyPlaying: _changecurrentPlayer()));
  }

  void _winningPlayer(WinningPlayer event, Emitter<GameState> emit) {
    // Efecto cuando gana un jugador.
    _audioWinning.setAudioSource(AudioSource.asset('assets/audios/winning-player.wav'));
    _audioWinning.seek(Duration.zero);
    _audioWinning.play();

    // Modifica la lista de las victoria y suma 1+ victoria al player ganador.
    final List<Map<Player, int>> winnersUpdate = state.winners.map((m) {
      if (m.keys.first.type == event.player.type) {
        m = {m.keys.first: m.values.first + 1};
      } 
      return m;
    }).toList();

    emit(state.copyWith(
        winningPlayer: event.player,
        indexesWithMach: event.indexesWithMach,
        winners: winnersUpdate
      )
    );
  }

  void _newGame(NewGame event, Emitter<GameState> emit) {
     emit(state.copyWith(
        currentlyPlaying: _changecurrentPlayer(),
        grid: state.gridDfault,
        winningPlayer: null,
        indexesWithMach: null
      )
    );
  }

  // Retorna el player que jugara.
  Player _changecurrentPlayer() => state.players.firstWhere((test) => test != state.currentlyPlaying);

  @override
  Future<void> close() {
    _audioButtonPress.dispose();
    _audioWinning.dispose();
    return super.close();
  }
}