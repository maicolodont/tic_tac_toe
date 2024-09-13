import 'package:flutter/material.dart';
import 'package:tic_tac_toe/data/models/player.dart';

/// Algoritmo para detectar mach
class DetectWinner {
  /// Retorna una lista de `int` posiciones en la grid de
  /// cada objeto que hizo mach.
  /// 
  /// * Para juego de 9 celdas.
  static List<int>?  cell9(List<String> grid) {
    // * El algoritmo verifica primero que la celda no este vacia.
    // * Busca un mach de 3 iguales en una linea trazada.

    // Buscar en lineas.
    // Linea: 1
    if (grid[0] != '' && grid[0] == grid[1] && grid[1] == grid[2]) {
      return [0,1,2];
    }

    // Linea: 2
    if (grid[3] != '' && grid[3] == grid[4] && grid[3] == grid[5]) {
      return [3,4,5];
    }

    // Linea: 3
    if (grid[6] != '' && grid[6] == grid[7] && grid[6] == grid[8]) {
      return [6,7,8];
    }

    // Buscar en columnas.
    // Columna: 1
    if (grid[0] != '' && grid[0] == grid[3] && grid[0] == grid[6]) {
      return [0,3,6];
    }

    // Columna: 2
    if (grid[1] != '' && grid[1] == grid[4] && grid[1] == grid[7]) {
      return [1,4,7];
    }

    // Columna: 3
    if (grid[2] != '' && grid[2] == grid[5] && grid[2] == grid[8]) {
      return [2,5,8];
    }

    // Buscar en vericalmente.
    // Vertical: 1
    if (grid[2] != '' && grid[2] == grid[4] && grid[2] == grid[6]) {
      return [2,4,6];
    }

    // Vertical: 2
    if (grid[0] != '' && grid[0] == grid[4] && grid[0] == grid[8]) {
      return [0,4,8];
    }
    return null;
  }

  static List<int>?  cell10(List<String> grid) {
    final List<List<Offset>> positions = [
      // Row 1.
      [const Offset(0,0),const Offset(0,1),const Offset(0,2)],
      // Row 2.
      [const Offset(1,0),const Offset(1,1),const Offset(1,2)],
      // Row 3.
      [const Offset(2,0),const Offset(2,1),const Offset(2,2)],

      // Column 1.
      [const Offset(0,0),const Offset(1,0),const Offset(2,0)],
      // Column 2.
      [const Offset(1,1),const Offset(2,1),const Offset(1,2)],
      // Column 3.
      [const Offset(2,0),const Offset(2,1),const Offset(2,2)],

      // Diagonal 1.
      [const Offset(0,0),const Offset(1,1),const Offset(2,2)],
      // Diagonal 2.
      [const Offset(0,2),const Offset(1,1),const Offset(2,0)],
    ];

    // Row.
    for (int row = 0; row < 3; row++) {
      if (grid[row] == grid[row +1] && grid[row +1] == grid[row +2]) {
        return [0,1,2];
      }
    }
    return null;
  }

  static TypePlayer stringToPlayer(String string) => 
    TypePlayer.values.singleWhere((test) => test.name == string);
}