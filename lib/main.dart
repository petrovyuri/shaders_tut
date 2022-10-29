import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  var updateTime = 0.0;

  @override
  void initState() {
    super.initState();
    createTicker((elapsed) {
      updateTime = elapsed.inMilliseconds / 1000;
      setState(() {});
    }).start();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FragmentProgram>(
      future: _initShader(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final shader = snapshot.data!.fragmentShader()
            ..setFloat(0, updateTime)
            ..setFloat(1, 300)
            ..setFloat(2, 300);
          return CustomPaint(painter: AnimRect(shader));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<FragmentProgram> _initShader() {
    return FragmentProgram.fromAsset("shader.glsl");
  }
}

class AnimRect extends CustomPainter {
  final Shader shader;

  AnimRect(this.shader);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.largest, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
