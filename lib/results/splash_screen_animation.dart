import 'dart:math';

import 'package:flutter/material.dart';

class SplashScreenAnimation extends StatefulWidget {
  const SplashScreenAnimation({Key? key}) : super(key: key);

  @override
  State<SplashScreenAnimation> createState() => _SplashScreenAnimationState();
}

class _SplashScreenAnimationState extends State<SplashScreenAnimation>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: -(pi / 2),
    ).animate(
        CurvedAnimation(parent: _rotationController, curve: Curves.bounceOut));
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.bounceOut),
    );

    _rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(
            parent: _flipController,
            curve: Curves.bounceOut,
          ),
        );

        _flipController
          ..reset()
          ..forward();
      }
    });

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rotationAnimation = Tween<double>(
          begin: _rotationAnimation.value,
          end: _rotationAnimation.value - (pi / 2),
        ).animate(CurvedAnimation(
            parent: _rotationController, curve: Curves.bounceOut));
        _rotationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(seconds: 1), () {
      _rotationController
        ..reset()
        ..forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(_rotationAnimation.value),
                child: AnimatedBuilder(
                  animation: _flipController,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..rotateY(_flipAnimation.value),
                      // child: Image.asset(
                      //   'assets/logo.png',
                      //   width: 200,
                      //   height: 200,
                      // ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
