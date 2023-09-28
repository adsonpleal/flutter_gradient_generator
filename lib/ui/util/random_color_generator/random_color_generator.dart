import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/abstract_random_color_generator.dart';
import 'dart:math';

class RandomColorGenerator implements AbstractRandomColorGenerator {
  const RandomColorGenerator();

  @override
  List<ColorAndStop>
      getRandomColorAndStopsOfCurrentGradientColorAndStopListLength(
          {required int currentGradientColorAndStopListLength}) {
    final List<Color> colorList =
        Colors.primaries.map((color) => color.shade500).toList();

    final int colorListLength = colorList.length;

    /// This represents the interval at which each color's stop position
    /// is calculated in the gradient.
    ///
    /// The '~/'' operator is used to discard the fractional part of the
    /// result of the division.
    final stopInterval = 100 ~/ currentGradientColorAndStopListLength;

    final Random random = Random();

    final List<ColorAndStop> randomColorsAndStops = [];

    for (int i = 0; i < currentGradientColorAndStopListLength; i++) {
      final int randomIndex = random.nextInt(colorListLength);

      final Color randomColor = colorList.elementAt(randomIndex);

      /// The stop position of the color in the gradient.
      final int stop = i * stopInterval;

      randomColorsAndStops.add(
        (color: randomColor, stop: stop),
      );
    }

    return randomColorsAndStops;
  }
}
