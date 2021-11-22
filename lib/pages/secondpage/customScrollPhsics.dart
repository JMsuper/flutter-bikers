import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/physics.dart';

class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  // velocity만큼의 geture 속도가 나타날 경우 fling한다.
  @override
  double get minFlingVelocity => 0.0;

  @override
  double get maxFlingVelocity => 7000.0;

  // distance만큼의 픽셀길이를 사용자가 드래그 했을때 fling한다.
  @override
  double get minFlingDistance => 10.0;

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    return ClampingScrollSimulation(
        position: position.pixels, velocity: velocity * 0.83, friction: 0.0035);
  }
}

class CustomSimulation extends Simulation {
  final double initPosition;
  final double velocity;
  CustomSimulation({required this.initPosition, required this.velocity});

  @override
  double x(double time) {
    var max =
        math.max(math.min(initPosition, 0.0), initPosition + velocity * time);
    print(max.toString());
    return max;
  }

  @override
  double dx(double time) {
    print(velocity.toString());
    return velocity;
  }

  @override
  bool isDone(double time) {
    return false;
  }
}