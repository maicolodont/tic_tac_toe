import 'package:flutter/material.dart';

/// Algoritmo para detectar mach.
class DetectWinner {
  /// Algoritmo para detectar mach de cuadricula de 9 celdas.
  static List<Offset>? cell9(List<List<String>> grid) {
    /// Todas las posibles combinaciones.
    /// 
    /// Las convinaciones inician desde la parte superior(0) de la cuadricula,
    /// esto ayuda a pintar las lineas de `CustomPaint` porque
    /// siempre se toma la `posicion 0` inicial para pintar y la `posicion 2`
    /// para finalizar. 
    final List<List<List<Offset>>> combinations = [
      [ 
        [const Offset(0,0),const Offset(0,1),const Offset(0,2)], // Row 1
        [const Offset(1,0),const Offset(1,1),const Offset(1,2)], // Row 2
        [const Offset(2,0),const Offset(2,1),const Offset(2,2)], // Row 3
      ],
      [ 
        [const Offset(0,0),const Offset(1,0),const Offset(2,0)], // Column 1
        [const Offset(0,1),const Offset(1,1),const Offset(2,1)], // Column 2
        [const Offset(0,2),const Offset(1,2),const Offset(2,2)], // Column 3
      ],
      [
        [const Offset(0,0),const Offset(1,1),const Offset(2,2)], // Diagonal 1
        [const Offset(0,2),const Offset(1,1),const Offset(2,0)], // Diagonal 2
      ],
    ];
    
    /// `grid[row][0] != ''` primero verifica que la primera posicion sea diferente de '',
    /// para asegurar que las comparaciones no se hagan usando solo ''.
    /// 
    // Rows.
    for (int row = 0; row < 3; row++) {
      if (grid[row][0] != '' && grid[row][0] == grid[row][1] && grid[row][0] == grid[row][2]) {
        return combinations[0][row];
      }
    }

    // Columns.
    for (int col = 0; col < 3; col++) {
      if (grid[0][col] != '' && grid[0][col] == grid[1][col] && grid[1][col] == grid[2][col]) {
        return combinations[1][col];
      }
    }

    // Diagonals (\).
    if (grid[0][0] != '' && grid[0][0] == grid[1][1] && grid[1][1] == grid[2][2]) {
      return combinations[2][0];
    }

    // Diagonals (\).
    if (grid[0][2] != '' && grid[0][2] == grid[1][1] && grid[1][1] == grid[2][0]) {
      return combinations[2][1];
    }
    return null;
  }
}