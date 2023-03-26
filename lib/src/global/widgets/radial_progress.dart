import 'dart:math';
import 'package:flutter/material.dart';

class PainterStyle {
  final double? strokeWidth;
  final PaintingStyle? paintingStyle;
  final bool showTrack;
  final bool showBackground;
  final Color startClr;
  final Color endClr;
  final Color? bgClr;
  final Color trackClr;

  const PainterStyle({
    required this.startClr,
    required this.endClr,
    this.bgClr,
    this.trackClr = const Color.fromARGB(255, 205, 205, 205),
    this.showTrack = true,
    this.showBackground = false,
    this.strokeWidth,
    this.paintingStyle,
  });
}

class RadialProgress extends StatefulWidget {
  final double progressValue;
  final TextStyle? valueStyle;
  final bool showThumb;
  final Widget? child;
  final double height;
  final double thumbHeight;
  final double thumbWidth;
  final double thumbPadding;
  final double width;
  final PainterStyle style;
  final Widget? thumb;

  const RadialProgress({
    required this.progressValue,
    required this.style,
    this.child,
    this.thumb,
    this.height = 100,
    this.width = 100,
    this.thumbHeight = 14,
    this.thumbWidth = 14,
    this.thumbPadding = 4,
    this.showThumb = true,
    this.valueStyle,
    super.key,
  });

  @override
  State<RadialProgress> createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress>
    with TickerProviderStateMixin {
  late final AnimationController _radialController;
  late final Animation<double> _radialAnimation;
  double progressDegrees = 0;
  final Duration fadeInDuration = const Duration(milliseconds: 500);
  final Duration fillDuration = const Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    _radialController = AnimationController(
      vsync: this,
      duration: fillDuration,
    );
    _radialAnimation = Tween<double>(begin: 0, end: 360).animate(
      CurvedAnimation(
        parent: _radialController,
        curve: Curves.fastOutSlowIn,
      ),
    )..addListener(() {
        progressDegrees = widget.progressValue * _radialAnimation.value;
      });
    _radialController.forward();
  }

  @override
  void didUpdateWidget(RadialProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style.startClr != widget.style.startClr ||
        oldWidget.style.endClr != widget.style.endClr ||
        oldWidget.style.bgClr != widget.style.bgClr) {
      _radialController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _radialAnimation.removeListener(() {});
    _radialController.dispose();
    super.dispose();
  }

  String get percent {
    return ((progressDegrees / 360.0) * 100).toStringAsPrecision(3);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _radialAnimation,
      builder: (context, child) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CustomPaint(
              painter: RadialPainter(
                degrees: progressDegrees,
                style: widget.style,
              ),
              child: SizedBox(
                height: widget.height - 16,
                width: widget.width - 16,
                child: AnimatedOpacity(
                  curve: Curves.fastLinearToSlowEaseIn,
                  opacity: double.parse(percent) > 0.3 ? 1.0 : 0.0,
                  duration: fadeInDuration,
                  child: Center(
                    child: widget.child ??
                        Text(
                          '$percent%',
                          style: widget.valueStyle ??
                              TextStyle(
                                color: widget.style.endClr,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                        ),
                  ),
                ),
              ),
            ),

            // Slider head
            Positioned.fill(
              child: Align(
                alignment: Alignment(
                  cos((2 * pi * progressDegrees / 360.0) - (pi / 2)),
                  sin((2 * pi * progressDegrees / 360.0) - (pi / 2)),
                ),
                child: child,
              ),
            )
          ],
        ),
      ),
      child: !widget.showThumb
          ? null
          : widget.thumb ??
              Material(
                animationDuration: fillDuration,
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: widget.thumbHeight,
                  height: widget.thumbWidth,
                  padding: EdgeInsets.all(widget.thumbPadding),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.style.endClr,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
    );
  }
}

class RadialPainter extends CustomPainter {
  final double degrees;
  final PainterStyle style;

  RadialPainter({
    required this.degrees,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = style.strokeWidth ?? 7.2;
    final rect = Rect.fromCircle(center: center, radius: size.width / 2);

    if (style.showBackground) {
      final circle1 = Paint()
        ..color = style.bgClr ?? style.endClr.withOpacity(0.2);
      final circle2 = Paint()..color = Colors.white;
      canvas
        ..drawCircle(center, size.width / 2, circle1)
        ..drawCircle(center, size.width / 4, circle2);
    }

    // Track paint
    if (style.showTrack) {
      final trackPaint = Paint()
        ..color = style.trackClr
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = style.strokeWidth ?? 7.2
        ..isAntiAlias = true;

      canvas.drawArc(
        rect,
        _degreeToRad(-90),
        _degreeToRad(360),
        false,
        trackPaint,
      );
    }

    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: <Color>[style.trackClr, style.startClr, style.endClr],
        stops: const [0.0, 0.1, 1.0],
        tileMode: TileMode.repeated,
        startAngle: 3 * pi / 2,
        endAngle: 7 * pi / 2,
      ).createShader(rect)
      ..strokeJoin = StrokeJoin.miter
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    final scapSize = strokeWidth / 2;
    final scapToDegree = scapSize / center.dy;

    canvas.drawArc(
      rect,
      _degreeToRad(-90) + scapToDegree,
      _degreeToRad(degrees) - scapToDegree * 2,
      false,
      progressPaint,
    );
  }

  double _degreeToRad(double degree) => degree * pi / 180;

  @override
  bool shouldRepaint(RadialPainter oldDelegate) {
    return oldDelegate.degrees != degrees;
  }
}
