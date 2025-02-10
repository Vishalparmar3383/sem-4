import 'dart:math';
import 'package:flutter/material.dart';

class HeartsAnimation extends StatefulWidget {
  const HeartsAnimation({super.key});

  @override
  _HeartsAnimationState createState() => _HeartsAnimationState();
}

class _HeartsAnimationState extends State<HeartsAnimation> with TickerProviderStateMixin {
  final Random _random = Random();
  final int heartCount = 20;
  final List<Heart> hearts = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < heartCount; i++) {
      final AnimationController controller = AnimationController(
        duration: Duration(seconds: _random.nextInt(5) + 4),
        vsync: this,
      )..repeat();

      hearts.add(Heart(
        startX: _random.nextDouble(),
        size: _random.nextDouble() * 20 + 10,
        speed: _random.nextDouble() * 0.5 + 0.6,
        controller: controller,
      ));
    }
  }

  @override
  void dispose() {
    for (final heart in hearts) {
      heart.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: hearts.map((heart) {
        return AnimatedBuilder(
          animation: heart.controller,
          builder: (context, child) {
            return Positioned(
              left: heart.startX * MediaQuery.of(context).size.width,
              bottom: (heart.controller.value * MediaQuery.of(context).size.height * heart.speed) % MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: 1 - (heart.controller.value * 0.7),
                child: Icon(
                  Icons.favorite,
                  size: heart.size,
                  color: Colors.redAccent.withOpacity(0.5),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class Heart {
  final double startX;
  final double size;
  final double speed;
  final AnimationController controller;

  Heart({
    required this.startX,
    required this.size,
    required this.speed,
    required this.controller,
  });
}
