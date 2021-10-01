import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Five-Starred Red Flag',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Five-Starred Red Flag'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: MouseRegion(
          onEnter: (e) {
            setState(() {
              _hover = true;
            });
          },
          onExit: (e) {
            setState(() {
              _hover = false;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: CustomPaint(
                painter: FiveStarredRedFlag(_hover),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FiveStarredRedFlag extends CustomPainter {
  final bool hover;

  FiveStarredRedFlag(this.hover);

  @override
  void paint(Canvas canvas, Size size) {
    final double itemSize = size.width / (15 * 2);
    final Paint paint = Paint();
    // 设置抗锯齿
    paint.isAntiAlias = true;
    hover
        ? _drawGrid(canvas, paint, size, itemSize)
        : _drawFlag(canvas, paint, size, itemSize);
  }

  void _drawGrid(Canvas canvas, Paint paint, Size size, double gridItemSize) {
    // 绘制背景
    paint
      ..style = PaintingStyle.fill
      ..color = const Color.fromARGB(255, 246, 138, 142);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // 设置背景色
    _drawFiveStar(canvas, paint, gridItemSize);

    /// 1. 先将旗面划分为4个等分长方形，再将左上方长方形划分长宽15×10个方格。
    paint
      ..style = PaintingStyle.stroke
      ..color = const Color.fromARGB(255, 8, 6, 6);
    // 绘制大格子
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    // 绘制中分线，分为四个格子
    final double halfHeight = size.height / 2;
    canvas.drawLine(
        Offset(0, halfHeight), Offset(size.width, halfHeight), paint);
    final double halfWidth = size.width / 2;
    canvas.drawLine(
        Offset(halfWidth, 0), Offset(halfWidth, size.height), paint);

    // 绘制左上角小格子
    // 绘制横向线条
    for (int i = 1; i < 10; ++i) {
      canvas.drawLine(Offset(0, i * gridItemSize),
          Offset(halfWidth, i * gridItemSize), paint);
    }
    // 绘制竖向线条
    for (int i = 1; i < 15; ++i) {
      canvas.drawLine(Offset(i * gridItemSize, 0),
          Offset(i * gridItemSize, halfHeight), paint);
    }

    /// 2. 大五角星的中心位于该长方形上5下5、左5右10之处。大五角星外接圆的直径为6单位长度。
    canvas.drawCircle(Offset(5 * gridItemSize, 5 * gridItemSize),
        6 / 2 * gridItemSize, paint);

    /// 3. 四颗小五角星的中心点，第一颗位于上2下8、左10右5，第二颗位于上4下6、左12右3，第三颗位于上7下3、左12右3，第四颗位于上9下1、左10右5之处。
    canvas.drawCircle(
        Offset(10 * gridItemSize, 2 * gridItemSize), gridItemSize, paint);
    canvas.drawCircle(
        Offset(12 * gridItemSize, 4 * gridItemSize), gridItemSize, paint);
    canvas.drawCircle(
        Offset(12 * gridItemSize, 7 * gridItemSize), gridItemSize, paint);
    canvas.drawCircle(
        Offset(10 * gridItemSize, 9 * gridItemSize), gridItemSize, paint);

    // 将所有的小圆圆心与大圆圆心相连
    canvas.drawLine(Offset(5 * gridItemSize, 5 * gridItemSize),
        Offset(10 * gridItemSize, 2 * gridItemSize), paint);
    canvas.drawLine(Offset(5 * gridItemSize, 5 * gridItemSize),
        Offset(12 * gridItemSize, 4 * gridItemSize), paint);
    canvas.drawLine(Offset(5 * gridItemSize, 5 * gridItemSize),
        Offset(12 * gridItemSize, 7 * gridItemSize), paint);
    canvas.drawLine(Offset(5 * gridItemSize, 5 * gridItemSize),
        Offset(10 * gridItemSize, 9 * gridItemSize), paint);
  }

  void _drawFlag(Canvas canvas, Paint paint, Size size, gridItemSize) {
    // 绘制背景
    paint
      ..style = PaintingStyle.fill
      ..color = const Color.fromARGB(255, 238, 28, 37);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    _drawFiveStar(canvas, paint, gridItemSize);
  }

  void _drawFiveStar(Canvas canvas, Paint paint, double gridItemSize) {
    /// 4. 每颗小五角星外接圆的直径均为2单位长度。四颗小五角星均有一角尖正对大五角星的中心点。
    // 设置背景色
    paint
      ..style = PaintingStyle.fill
      ..color = const Color.fromARGB(255, 255, 255, 0);

    // 绘制大五角星
    _drawStar(canvas, paint, Offset(5 * gridItemSize, 5 * gridItemSize),
        6 / 2 * gridItemSize);
    // 绘制小五角星
    _drawStar(
      canvas,
      paint,
      Offset(10 * gridItemSize, 2 * gridItemSize),
      gridItemSize,
      offset: (270 -
              math.asin(3 / math.sqrt(math.pow(3, 2) + math.pow(5, 2))) *
                  180 /
                  math.pi) *
          math.pi /
          180,
    );
    _drawStar(
      canvas,
      paint,
      Offset(12 * gridItemSize, 4 * gridItemSize),
      gridItemSize,
      offset: (270 -
              math.asin(1 / math.sqrt(math.pow(7, 2) + math.pow(1, 2))) *
                  180 /
                  math.pi) *
          math.pi /
          180,
    );
    _drawStar(
      canvas,
      paint,
      Offset(12 * gridItemSize, 7 * gridItemSize),
      gridItemSize,
      offset: (360 -
              math.asin(7 / math.sqrt(math.pow(7, 2) + math.pow(2, 2))) *
                  180 /
                  math.pi) *
          math.pi /
          180,
    );
    _drawStar(
      canvas,
      paint,
      Offset(10 * gridItemSize, 9 * gridItemSize),
      gridItemSize,
      offset: (360 -
              math.asin(5 / math.sqrt(math.pow(4, 2) + math.pow(5, 2))) *
                  180 /
                  math.pi) *
          math.pi /
          180,
    );
  }

  void _drawStar(
    Canvas canvas,
    Paint paint,
    Offset center,
    double radius, {
    double offset = 0,
  }) {
    final Path path = Path();
    final List<Offset> points = [];
    // 获得五个顶点的坐标
    for (int i = 0; i < 5; i++) {
      // math.pi / 2 -> 90°
      // math.pi / 2.5 -> 72°
      // 每个点偏移的角度
      final double degree = math.pi / 2 + i * math.pi / 2.5 + offset;
      // 计算每个点的x，y坐标
      points.add(Offset(center.dx - (radius * math.cos(degree)),
          center.dy - (radius * math.sin(degree))));
    }
    // 将绘制点移到第一个点顶点
    path.moveTo(points[0].dx, points[0].dy);
    // 点与点之间的连接顺序为：0 -> 2 -> 4 -> 1 -> 3 -> 0
    path.lineTo(points[2].dx, points[2].dy);
    path.lineTo(points[4].dx, points[4].dy);
    path.lineTo(points[1].dx, points[1].dy);
    path.lineTo(points[3].dx, points[3].dy);
    path.lineTo(points[0].dx, points[0].dy);
    // 绘制路径
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FiveStarredRedFlag oldDelegate) {
    return oldDelegate.hover != hover;
  }
}
