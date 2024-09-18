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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/bloc/cubits/timer_controller.dart';
import 'package:uicons_pro/uicons_pro.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key, required this.controller});
  final TimerController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          colors: [
            Color(0xFF6BE83D), // Verde claro para el centro
            Color(0xFF35B837), // Verde más oscuro para el borde
          ],
          center: Alignment.center,
          radius: 0.8,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 7)
          ),
        ],
      ),
      child: BlocBuilder<TimerController, int>(
        bloc: controller,
        builder: (context, state) {
          return controller.seconds > 0 
            ? Text(
              '00:${state.toString().padLeft(2, '0')}',
              textAlign: TextAlign.center,
              style: GoogleFonts.oxanium(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w800
              ),
            )
          : Icon(UIconsPro.boldRounded.infinity, color: Colors.white, size: 40);
        },
      )
    );
  }
}