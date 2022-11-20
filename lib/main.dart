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
  var _move = 0.0;
  var _stop = 0.0;

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
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<FragmentProgram>(
          future: _initShader(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final shader = snapshot.data!.fragmentShader()
                ..setFloat(0, updateTime)
                ..setFloat(1, 300)
                ..setFloat(2, 300)
                ..setFloat(3, _move)
                ..setFloat(4, _stop);
              return Stack(
                children: [
                  CustomPaint(painter: AnimRect(shader)),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                      onPressed: () {
                        if (_move == 1) {
                          _move = 0.0;
                        } else {
                          _move = 1;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        if (_stop == 1) {
                          _stop = 0.0;
                        } else {
                          _stop = 1;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
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
