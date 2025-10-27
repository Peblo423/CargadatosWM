import 'dart:math' as math;

class WaterDrop {
  final double delay;
  final double xPosition;
  final double size;

  WaterDrop({required this.delay})
      : xPosition = 30 + math.Random().nextDouble() * 80,
        size = 15 + math.Random().nextDouble() * 15;
}