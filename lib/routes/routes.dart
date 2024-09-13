import 'package:go_router/go_router.dart';
import 'package:tic_tac_toe/presentation/screens/game_screen.dart';
import 'package:tic_tac_toe/presentation/screens/home_screen.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/game',
      name: 'game',
      builder: (context, state) => GameScreen(duration: state.extra as Duration),
    )
  ]
);