import 'dart:math';
import 'package:flutter/material.dart';

class ChangeColors extends StatefulWidget {
  const ChangeColors({super.key});

  @override
  State<ChangeColors> createState() => _ChangeColorsState();
}

class _ChangeColorsState extends State<ChangeColors> {
  Color bgcolor = Colors.white;
  String bgcolorString = 'Trắng';

  final List<String> listColorString = [
    'Xanh lá',
    'Xanh dương',
    'Trắng',
    'Hồng',
    'Vàng',
    'Đỏ',
    'Cam',
    'Xám',
    'Tím',
  ];

  final List<Color> listColor = [
    Colors.green,
    Colors.blue,
    Colors.white,
    Colors.pink,
    Colors.yellow,
    Colors.red,
    Colors.orange,
    Colors.grey,
    Colors.purple,
  ];

  void _changeColor() {
    setState(() {
      var random = Random();
      var r = random.nextInt(listColor.length);
      bgcolor = listColor[r];
      bgcolorString = listColorString[r];
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark =
        ThemeData.estimateBrightnessForColor(bgcolor) == Brightness.dark;
    Color contentColor = isDark ? Colors.white : Colors.black;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgcolor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TIỆN ÍCH GIẢI TRÍ",
              style: TextStyle(
                fontSize: 14,
                color: contentColor.withOpacity(0.6),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Đổi Màu Nền",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: contentColor,
              ),
            ),
            const SizedBox(height: 100),
            Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: contentColor.withOpacity(0.1)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "MÀU HIỆN TẠI",
                      style: TextStyle(
                        color: contentColor.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      bgcolorString.toUpperCase(),
                      style: TextStyle(
                        color: contentColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 200,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _changeColor,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: contentColor,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "ĐỔI MÀU",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
