import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const ConfettiOverlay({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 2));
    _controller.play();
    
    // После завершения анимации закрыть
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,
        particleDrag: 0.05,
        emissionFrequency: 0.05,
        numberOfParticles: 50,
        gravity: 0.1,
        shouldLoop: false,
        colors: const [
          Color(0xFF1A7A4A),
          Color(0xFF2ECC71),
          Color(0xFFF1C40F),
          Color(0xFFE67E22),
          Color(0xFF3498DB),
        ],
        strokeColor: Colors.white,
        strokeWidth: 0,
        child: SizedBox.expand(
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
