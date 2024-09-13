enum TypePlayer {x,o}

class Player {
  Player({
    required this.name,
    required this.type  
  });

  final String name;
  final TypePlayer type;

  String get icon => 
    type == TypePlayer.x
    ? 'assets/images/icons/battery.svg'
    : 'assets/images/icons/flying-disc.svg';
}