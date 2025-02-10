import 'package:flutter/material.dart';
import 'package:submisson_project/layouts/heart_animation.dart';
import 'dart:async';
import 'homepage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _doorAnimation;
  bool _animationStarted = false;
  double _textOpacity = 1.0;
  double _heartOpacity = 1.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _doorAnimation = Tween<double>(begin: 0.0, end: 1.57).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _startAnimation() {
    if (!_animationStarted) {
      setState(() {
        _animationStarted = true;
        _textOpacity = 0.0;
      });

      _controller.forward();

      Future.delayed(const Duration(milliseconds: 1600), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MyHomepage(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(child: const MyHomepage()),
          // Left Door
          AnimatedBuilder(
            animation: _doorAnimation,
            builder: (context, child) {
              return Positioned(
                left: 0,
                child: Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0005)
                    ..rotateY(-_doorAnimation.value),
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.5,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: screenWidth,
                        height: screenHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Right Door
          AnimatedBuilder(
            animation: _doorAnimation,
            builder: (context, child) {
              return Positioned(
                right: 0,
                child: Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0005)
                    ..rotateY(_doorAnimation.value),
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.centerRight,
                      widthFactor: 0.5,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: screenWidth,
                        height: screenHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1500),
              opacity: _textOpacity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome to Matrimony",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startAnimation,
                    child: const Text("Start"),
                  ),
                ],
              ),
            ),
          ),
          AnimatedOpacity(
            duration: Duration(milliseconds: 0),
            opacity: _heartOpacity,
            child: HeartsAnimation(),
          ),
        ],
      ),
    );
  }
}
