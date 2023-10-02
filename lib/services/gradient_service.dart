import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_typedefs.dart';
import 'package:flutter_gradient_generator/enums/gradient_direction.dart';
import 'package:flutter_gradient_generator/enums/gradient_style.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';
import 'package:flutter_gradient_generator/models/gradient_factory.dart';
import 'package:flutter_gradient_generator/models/linear_style_gradient.dart';
import 'package:flutter_gradient_generator/ui/util/new_color_generator/new_color_generator.dart';
import 'package:flutter_gradient_generator/ui/util/new_color_generator/new_color_generator_interface.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/abstract_random_color_generator.dart';
import 'package:flutter_gradient_generator/ui/util/random_color_generator/random_color_generator.dart';
import 'package:flutter_gradient_generator/utils/color_and_stop_util.dart';

class GradientService with ChangeNotifier {
  final AbstractRandomColorGenerator _randomColorGenerator =
      const RandomColorGenerator();

  late final AbstractGradient _defaultGradient = LinearStyleGradient(
      colorAndStopList: _randomColorGenerator
          .getRandomColorAndStopsOfCurrentGradientColorAndStopListLength(
        currentStopList: ColorAndStopUtil().initialStopList,
      ),
      gradientDirection: GradientDirection.topLeft);

  final NewColorGeneratorInterface _newColorGenerator = NewColorGenerator();

  int _currentSelectedColorIndex = 0;

  late AbstractGradient gradient = _defaultGradient;

  /// The index of the currently selected color in the color list being
  /// showned on the [GeneratorSection]
  int get currentSelectedColorIndex => _currentSelectedColorIndex;

  set currentSelectedColorIndex(int newCurrentSelectedColorIndex) {
    if (newCurrentSelectedColorIndex != currentSelectedColorIndex) {
      _currentSelectedColorIndex = newCurrentSelectedColorIndex;
      notifyListeners();
    }
  }

  void addNewColor() {
    final (:startColorAndStop, :endColorAndStop) =
        _getColorAndStopsForNewColorAddition();

    final newColorAndStop = _newColorGenerator.generateNewColorAndStopBetween(
        startColorAndStop: startColorAndStop, endColorAndStop: endColorAndStop);

    if (newColorAndStop == null) {
      return;
    }

    onNewColorAndStopAdded(newColorAndStop);
  }

  void changeColor({
    required Color newColor,
    required int currentColorAndStopIndex,
  }) {
    final colorAndStopList = gradient.getColorAndStopList();

    // ignore: unused_local_variable
    final (:color, :stop) =
        colorAndStopList.elementAt(currentColorAndStopIndex);

    final newColorAndStop = (
      color: newColor,
      stop: stop,
    );

    /// Creates a copy of the `colorAndStopList` so modifying the new list does not modify `colorAndStopList`
    final List<ColorAndStop> newColorAndStopList = List.from(colorAndStopList);
    newColorAndStopList[currentColorAndStopIndex] = newColorAndStop;

    _onColorAndStopListChanged(newColorAndStopList,
        index: currentColorAndStopIndex);
  }

  void changeStop({
    required int newStop,
    required int currentColorAndStopIndex,
  }) {
    final colorAndStopList = gradient.getColorAndStopList();

    // ignore: unused_local_variable
    final (:color, :stop) =
        colorAndStopList.elementAt(currentColorAndStopIndex);

    final newColorAndStop = (
      color: color,
      stop: newStop,
    );

    /// Creates a copy of the `colorAndStopList` so modifying the new list does not modify `colorAndStopList`
    final List<ColorAndStop> newColorAndStopList = List.from(colorAndStopList);
    newColorAndStopList[currentColorAndStopIndex] = newColorAndStop;

    _onColorAndStopListChanged(newColorAndStopList,
        index: currentColorAndStopIndex);
  }

  /// Deletes the currently selected [ColorAndStop] if there are more than
  /// [minimumNumberOfColors] colors in the gradient.
  void deleteSelectedColorAndStopIfMoreThanMinimum(
      {required int indexToDelete}) {
    final currentColorAndStopList = gradient.getColorAndStopList();

    final colorAndStopListIsMoreThanMinimum = ColorAndStopUtil()
        .isColorAndStopListMoreThanMinimum(currentColorAndStopList);

    /// Only delete the currently selected [ColorAndStop] if there are more than
    /// [minimumNumberOfColors] colors in the gradient.
    if (colorAndStopListIsMoreThanMinimum) {
      final colorAndStopToDelete = currentColorAndStopList[indexToDelete];

      _onColorAndStopDeleted(colorAndStopToDelete);
    }
  }

  void changeGradientDirection(GradientDirection newGradientDirection) {
    if (gradient.getGradientDirection() != newGradientDirection) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: gradient.getGradientStyle(),
        colorAndStopList: gradient.getColorAndStopList(),
        gradientDirection: newGradientDirection,
      );

      gradient = newGradient;

      notifyListeners();
    }
  }

  void changeGradientStyle(GradientStyle newGradientStyle) {
    if (gradient.getGradientStyle() != newGradientStyle) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: newGradientStyle,
        colorAndStopList: gradient.getColorAndStopList(),
        gradientDirection: gradient.getGradientDirection(),
      );

      gradient = newGradient;

      notifyListeners();
    }
  }

  void onNewColorAndStopAdded(ColorAndStop newColorAndStop) {
    final List<ColorAndStop> colorAndStopListCopy =
        List<ColorAndStop>.from(gradient.getColorAndStopList());

    colorAndStopListCopy.add(newColorAndStop);

    colorAndStopListCopy.sort((a, b) => a.stop.compareTo(b.stop));

    final updatedColorAndStopList = colorAndStopListCopy;

    final newColorAndStopIndex =
        updatedColorAndStopList.lastIndexOf(newColorAndStop);

    _onColorAndStopListChanged(updatedColorAndStopList,
        index: newColorAndStopIndex);
  }

  void randomizeColors() {
    final newColorAndStopList = _randomColorGenerator
        .getRandomColorAndStopsOfCurrentGradientColorAndStopListLength(
      currentStopList:
          gradient.getColorAndStopList().map((e) => e.stop).toList(),
    );

    _onColorAndStopListChanged(newColorAndStopList,
        index: currentSelectedColorIndex);
  }

  ({ColorAndStop? startColorAndStop, ColorAndStop? endColorAndStop})
      _getColorAndStopsForNewColorAddition() {
    final colorAndStopList = gradient.getColorAndStopList();

    ColorAndStop? startColorAndStop;
    ColorAndStop? endColorAndStop;

    const firstIndex = 0;
    final lastIndex = colorAndStopList.length - 1;

    if (currentSelectedColorIndex == firstIndex) {
      const secondIndex = firstIndex + 1;

      startColorAndStop = colorAndStopList.elementAtOrNull(firstIndex);
      endColorAndStop = colorAndStopList.elementAtOrNull(secondIndex);
    } else if (currentSelectedColorIndex == lastIndex) {
      startColorAndStop =
          colorAndStopList.elementAtOrNull(currentSelectedColorIndex);
      endColorAndStop = null;
    } else {
      final nextIndex = currentSelectedColorIndex + 1;

      startColorAndStop =
          colorAndStopList.elementAtOrNull(currentSelectedColorIndex);
      endColorAndStop = colorAndStopList.elementAtOrNull(nextIndex);
    }

    return (
      startColorAndStop: startColorAndStop,
      endColorAndStop: endColorAndStop
    );
  }

  void _onColorAndStopDeleted(ColorAndStop colorAndStopToDelete) {
    final List<ColorAndStop> colorAndStopListCopy =
        List<ColorAndStop>.from(gradient.getColorAndStopList());

    colorAndStopListCopy.remove(colorAndStopToDelete);

    final updatedColorAndStopList = colorAndStopListCopy;

    final indexBeforeCurrentSelectedColorIndex = currentSelectedColorIndex - 1;

    final newSelectedColorIndex = indexBeforeCurrentSelectedColorIndex < 0
        ? 0
        : indexBeforeCurrentSelectedColorIndex;

    _onColorAndStopListChanged(updatedColorAndStopList,
        index: newSelectedColorIndex);
  }

  void _onColorAndStopListChanged(List<ColorAndStop> newColorAndStopList,
      {required int index}) {
    if (!const ListEquality<ColorAndStop>()
        .equals(gradient.getColorAndStopList(), newColorAndStopList)) {
      final AbstractGradient newGradient = GradientFactory().getGradient(
        gradientStyle: gradient.getGradientStyle(),
        colorAndStopList: newColorAndStopList,
        gradientDirection: gradient.getGradientDirection(),
      );

      gradient = newGradient;
      currentSelectedColorIndex = index;

      notifyListeners();
    }
  }
}

class GradientServiceProvider extends InheritedNotifier<GradientService> {
  final GradientService gradientService;

  const GradientServiceProvider(
      {super.key, required super.child, required this.gradientService})
      : super(notifier: gradientService);

  static GradientServiceProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GradientServiceProvider>();
  }

  static GradientServiceProvider of(BuildContext context) {
    final gradientService = GradientServiceProvider.maybeOf(context);
    assert(gradientService != null,
        'No GradientService found in context. Wrap your app in a GradientService widget.');
    return gradientService!;
  }
}
