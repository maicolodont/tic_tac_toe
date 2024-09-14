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