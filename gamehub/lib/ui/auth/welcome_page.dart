import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../auth/login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08080A),
      body: Stack(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 2 * math.pi),
            duration: const Duration(seconds: 15),
            builder: (context, value, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -50 + (math.sin(value) * 30),
                    right: -50 + (math.cos(value) * 20),
                    child: _buildBlurOrb(
                      350,
                      Colors.deepPurpleAccent.withOpacity(0.4),
                    ),
                  ),
                  Positioned(
                    bottom: -100 + (math.cos(value) * 40),
                    left: -50 + (math.sin(value) * 20),
                    child: _buildBlurOrb(
                      400,
                      const Color(0xFF6366F1).withOpacity(0.2),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  _fadeIn(
                    delay: 0,
                    child: const Text(
                      "GAMEHUB",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _fadeIn(
                    delay: 200,
                    child: const Text(
                      "MORE\nTHAN JUST\nCOLLECTION",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        height: 0.95,
                        letterSpacing: -3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _fadeIn(
                    delay: 400,
                    child: Text(
                      "Experience the ultimate library management with our seamless interface.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  _fadeIn(
                    delay: 600,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurpleAccent.withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "GET STARTED",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _fadeIn({required Widget child, required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
