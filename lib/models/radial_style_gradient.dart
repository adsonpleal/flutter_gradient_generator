import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:quiver/core.dart';

// ignore: must_be_immutable
class RadialStyleGradient extends AbstractGradient {
  RadialStyleGradient(
      {required List<Color> colorList,
      required List<int> stopList,
      required GradientDirection gradientDirection})
      : super(
          colorList: colorList,
          stopList: stopList,
          gradientDirection: gradientDirection,
        );

  final double _radialGradientRadius = 0.8;

  String get _widgetStringTemplate => '''RadialGradient(
          colors: ${getColorList()},
          stops: ${getStopListForFlutterCode()},
          center: $centerAlignment,
          radius: $_radialGradientRadius,
        )
        ''';

  @visibleForTesting
  Alignment get centerAlignment {
    Alignment alignment;

    switch (getGradientDirection()) {
      case GradientDirection.topLeft:
        alignment = Alignment.topLeft;
        break;
      case GradientDirection.topCenter:
        alignment = Alignment.topCenter;
        break;
      case GradientDirection.topRight:
        alignment = Alignment.topRight;
        break;
      case GradientDirection.centerLeft:
        alignment = Alignment.centerLeft;
        break;
      case GradientDirection.center:
        alignment = Alignment.center;
        break;
      case GradientDirection.centerRight:
        alignment = Alignment.centerRight;
        break;
      case GradientDirection.bottomLeft:
        alignment = Alignment.bottomLeft;
        break;
      case GradientDirection.bottomCenter:
        alignment = Alignment.bottomCenter;
        break;
      case GradientDirection.bottomRight:
        alignment = Alignment.bottomRight;
        break;
    }

    return alignment;
  }

  @override
  String toWidgetString() {
    return _widgetStringTemplate;
  }

  @override
  GradientStyle getGradientStyle() {
    return GradientStyle.radial;
  }

  @override
  Gradient toFlutterGradient() {
    return RadialGradient(
      colors: getColorList(),
      center: centerAlignment,
      radius: _radialGradientRadius,
      stops: getStopListForFlutterCode(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadialStyleGradient &&
          runtimeType == other.runtimeType &&
          toWidgetString() == other.toWidgetString() &&
          getGradientStyle() == other.getGradientStyle() &&
          toFlutterGradient() == other.toFlutterGradient();

  @override
  int get hashCode => hash3(toWidgetString().hashCode,
      getGradientStyle().hashCode, toFlutterGradient().hashCode);
}
