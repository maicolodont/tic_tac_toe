import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/providers/timer_controller.dart';
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
      child: ChangeNotifierProvider(
        create: (context) => controller,
        builder: (_,__) {
          return Consumer<TimerController>(
            builder: (_,value, __) {
              return value.seconds > 0 
                ? Text(
                  '00:${value.remainingTime.toString().padLeft(2, '0')}',
                  style: GoogleFonts.oxanium(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800
                  ),
                )
              : Icon(UIconsPro.boldRounded.infinity, color: Colors.white, size: 40);
            },
          );
        },
      ),
    );
  }
}