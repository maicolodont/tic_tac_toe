import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.setAudioSource(AudioSource.asset('assets/audios/button-press-2.wav'));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        _background(),
        _circular(),
        _content(context)
      ],
    );
  }

  Widget _background() {
    return SvgPicture.asset(
      'assets/images/background/home_background.svg',
      width: double.maxFinite,
      height: double.maxFinite,
      fit: BoxFit.cover,
    );
  }

  Widget _circular() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.03)
      ),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.08)
        ),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2)
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _gift(),
        const Gap(20),
        _buttons(context)
      ],
    );
  }

  Widget _gift() {
    return SvgPicture.asset(
      'assets/images/icons/gift.svg',
      width: 100,
      fit: BoxFit.cover,
    );
  }

  Widget _buttons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _button(title: 'Partida local', onTap: () => modal(context)),
        const Gap(10),
        _button(title: 'Sala privada', onTap: () => {})
      ],
    );
  }

  Widget _button({
    required String title,
    void Function()? onTap
  }) {
    return SizedBox(
      width: 240,
      child: OutlinedButton(
        onPressed: onTap,
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.green),
          overlayColor: WidgetStatePropertyAll(Color(0xFF3C973F)),
          side: WidgetStatePropertyAll(BorderSide(color: Colors.white, width: 2)),
          padding: WidgetStatePropertyAll(EdgeInsets.all(8))
        ),
        child: Text(
          title,
          style: GoogleFonts.oxanium(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w800
          ),
        )
      ),
    );
  }

  void modal(BuildContext context) {
    final List<Duration> durations = [
      const Duration(),
      const Duration(seconds: 3),
      const Duration(seconds: 5),
      const Duration(seconds: 10)
    ]; 
    Duration durationSelected = durations.first;

    showAdaptiveDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
              borderRadius: BorderRadius.circular(20),
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFFFC837), // Verde claro para el centro
                  Color(0xFFFF8008), // Verde más oscuro para el borde
                ],
                center: Alignment.center,
                radius: 0.8,
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/male.svg',
                  width: 100,
                ),
                const Gap(10),
                Text(
                  'Tiempo por jugada',
                  style: GoogleFonts.oxanium(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800
                  ),
                ),
                const Gap(5),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 7,
                      spacing: 7,
                      children: durations.map((duration) {
                        return _chip(
                          label: '00:${duration.inSeconds.toString().padLeft(2, '0')}',
                          duration: duration,
                          durationSelected: durationSelected,
                          onSelected: (selected) {
                            audioPlayer.seek(Duration.zero);
                            audioPlayer.setVolume(0.5);
                            audioPlayer.play();
                            setState(() {
                              durationSelected = duration;
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        context.pop();
                        context.pushNamed('game', extra: durationSelected);
                      },
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(Colors.green),
                        side: const WidgetStatePropertyAll(BorderSide(color: Colors.white, width: 3)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      ),
                      child: Text(
                        'Jugar',
                        style: GoogleFonts.oxanium(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w800
                        ),
                      )
                    ),
                    OutlinedButton(
                      onPressed: () => context.pop(),
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(Color(0xFF9d5002)),
                        side: const WidgetStatePropertyAll(BorderSide(color: Colors.white, width: 3)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      ),
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.oxanium(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w800
                        ),
                      )
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chip({
    required String label,
    required Duration duration,
    required Duration durationSelected,
    void Function(bool)? onSelected 
  }) {
    return ChoiceChip(
      selected: duration == durationSelected,
      onSelected: onSelected,
      tooltip: label,
      label: Text(
        label,
        style: GoogleFonts.oxanium(
          color: Colors.white,
          fontSize: 20
        )
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      side: BorderSide.none,
      checkmarkColor: Colors.white,
      selectedColor: const Color(0xFF9d5002),
      backgroundColor: const Color.fromARGB(255, 230, 105, 3),
    );
  }
}