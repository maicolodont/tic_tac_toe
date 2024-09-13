import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/bloc/game/game_bloc.dart';
import 'package:tic_tac_toe/bloc/game/game_event.dart';
import 'package:tic_tac_toe/bloc/game/game_state.dart';
import 'package:tic_tac_toe/data/models/player.dart';
import 'package:tic_tac_toe/presentation/widgets/timer/timer.dart';
import 'package:tic_tac_toe/providers/timer_controller.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.duration});
  /// Duracion de cada turno del jugador.
  final Duration? duration;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final List<Player> players = [
    Player(name: "Player #1", type: TypePlayer.x),
    Player(name: "Player #2", type: TypePlayer.o),
  ];
  late final GameBloc gameBloc;
  late TimerController timerController;
  late AnimationController arrowAnimationController;
  late Animation<double> arrowAnimation;
  late AnimationController flickerAnimationController;
  late Animation<Color?> flickerAnimation;

  @override
  void initState() {
    super.initState(); 
    gameBloc = GameBloc(players: players);

    arrowAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this
    )..repeat(reverse: true);

    arrowAnimation = Tween<double>(begin: 0, end: 20)
    .animate(CurvedAnimation(parent: arrowAnimationController, curve: Curves.easeInOut));

    flickerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), 
    )..repeat(reverse: true);

    flickerAnimation = ColorTween(
      begin: const Color(0xFF397E1F),
      end: const Color(0xFF31A833),
    ).animate(flickerAnimationController);

    timerController = TimerController(
      seconds: widget.duration?.inSeconds ?? 0, 
      autoReset: true,
      callBack: () {
        if (widget.duration != null && (widget.duration?.inSeconds ?? 0) > 0) {
          gameBloc.add(ChangecurrentPlayer());
        }
      },
    );
  }

  @override
  void dispose() {
    arrowAnimationController.dispose();
    timerController.cancel();
    flickerAnimationController.dispose();
    gameBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      extendBodyBehindAppBar: true,
      appBar: _AppBar(gameBloc: gameBloc),
      body: _body(),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        _background(),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              time(),
              const Gap(20),
              playersContainer(),
              const Gap(10),
              _grid()
            ],
          ),
        )
      ],
    );
  }

  Widget _background() {
    return SvgPicture.asset(
      'assets/images/background/game_background.svg',
      width: double.maxFinite,
      height: double.maxFinite,
      fit: BoxFit.cover,
    );
  }

  Widget time() => Container(
    width: 100,
    padding: const EdgeInsets.only(top: 20),
    child: TimerWidget(controller: timerController),
  );

  Widget playersContainer() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          playerContainer(players[0]),
          const Gap(10),
          playerContainer(players[1])
        ],
      ),
    );
  }

  Widget playerContainer(Player player) {
    final image = player.type == TypePlayer.x 
      ? 'assets/images/avatars/avatar-1.svg'
      : 'assets/images/avatars/avatar-2.svg';

    return BlocBuilder<GameBloc, GameState>(
      bloc: gameBloc,
      builder: (context, state) {
        final int wins = state.winners.singleWhere((test) => test.keys.first.type == player.type).values.first;
        return Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      image,
                      width: 50,
                    ),
                    const Gap(10),
                    Flexible(
                      child: Column(
                        children: [
                          Text(
                            player.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.oxanium(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              
                            ),
                          ),
                          const Gap(5),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  player.icon,
                                  width: 25,
                                ),
                                const Gap(3),
                                Text(
                                  wins.toString(),
                                  style: GoogleFonts.oxanium(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800
                                  ),
                                )
                              ],
                            ),
                          ),                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              player.type == state.currentlyPlaying.type
              ? Positioned(
                top: -75,
                child: AnimatedBuilder(
                  animation: arrowAnimation, 
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, arrowAnimation.value),
                      child: SvgPicture.asset(
                        'assets/images/icons/cursor-down2.svg',
                        width: 50
                      ),
                    ); 
                  },
                ),
              )
              : Container()
            ]
          ),
        );
      },
    );
  }

  Widget _grid() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.53,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double gridWidth = constraints.maxWidth;
          final double gridHeight = constraints.maxHeight;
      
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10)
            ),
            child: BlocConsumer<GameBloc, GameState>(
              bloc: gameBloc,
              listener: (context, state) {
                if (state.winningPlayer != null) {
                  winningPlayer();
                }
              },
              builder: (context, state) {
                // final positions = state.indexesWithMach?.map((position) => Offset(position, dy)).toList();
                List<Offset> matchPositions = [
                  Offset(0, 0),  // Primer elemento (fila 0, columna 0)
                  Offset(1, 1),  // Segundo elemento (fila 1, columna 0)
                  Offset(2, 2),  // Tercer elemento (fila 2, columna 0)
                ];
                return CustomPaint(
                  painter: DrawLine(matchPositions),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: gridWidth / (size.height - gridHeight)
                    ),
                    itemCount: state.grid.length,
                    itemBuilder: (context, index) {
                      final bool match = state.indexesWithMach?.contains(index) ?? false;
                      return _buttonTap(indexPosition: index, match: match);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buttonTap({required int indexPosition, bool match = false}) {
    final currentValue = gameBloc.state.grid[indexPosition];
    final icon = Player(name: '', type: currentValue == TypePlayer.x.name ? TypePlayer.x : TypePlayer.o).icon;

    return AnimatedBuilder(
      animation: flickerAnimationController,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        /// `currentValue` asegura que la celda solo se puede marcar si esta vacia.
        /// `gameBloc.state.winningPlayer` asegura que mientras se muestra el efecto 
        ///  de que hay un ganador no se pueda marcar una celda.
        onTap: currentValue == '' && gameBloc.state.winningPlayer == null ? () {
          gameBloc.add(Play(gameBloc.state.currentlyPlaying, indexPosition));
          timerController.reset();
        } : null,
        child: currentValue != '' 
        ? Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SvgPicture.asset(icon),
          )
        )
        : null
      ),
      builder: (context, child) {
        return Material(
          borderRadius: BorderRadius.circular(10),
          color: match 
            ? flickerAnimation.value
            :Colors.black.withOpacity(0.2),
          child: child,
        );
      },
    );
  }

  // Cuando hay un ganador el contador se pone en pausa
  // y la animacion por unos segundos y luego reinicia el juego.
  void winningPlayer() {
    timerController.pause();
    arrowAnimationController.reset();

    Future.delayed(const Duration(seconds: 2), () {
      timerController.starOver();
      arrowAnimationController.repeat(reverse: true);
      gameBloc.add(NewGame());
    });
  }
}

class DrawLine extends CustomPainter {
  DrawLine(this.positions);
  final List<Offset> positions;

  @override
  void paint(Canvas canvas, Size size) {
    final myPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.white
    ..strokeWidth = 10;

    final start = _draw(positions[0], size);
    final end = _draw(positions[2], size);

    canvas.drawLine(start, end, myPaint);
  }

  Offset _draw(Offset position, Size size) {
    final cellWidth = size.width / 3;
    final cellheight = size.height / 3;

    final x = position.dx * cellWidth + cellWidth / 2;
    final y = position.dy * cellheight + cellheight / 2;
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
   return true;
  }

}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {

  const _AppBar({required this.gameBloc});
  final GameBloc gameBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      bloc: gameBloc,
      builder: (context, state) {
        return AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: SvgPicture.asset(
              'assets/images/icons/cursor-left-2.svg',
              width: 40,
            )
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'VS',
            textAlign: TextAlign.center,
            style: GoogleFonts.oxanium(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.w800
            ),
          ),
        );
      },
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}