import 'package:flutter/material.dart';
import 'package:flutter_gradient_generator/data/app_colors.dart';
import 'package:flutter_gradient_generator/data/app_dimensions.dart';
import 'package:flutter_gradient_generator/ui/widgets/buttons/compact_button.dart';

class ColorSelectionWidget extends StatelessWidget {
  const ColorSelectionWidget({
    Key? key,
    required this.colorList,
  }) : super(key: key);

  final List<Color> colorList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colors',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            ...colorList.map(
              (color) {
                final int index = colorList.indexOf(color);
                final int lastIndex = colorList.length - 1;

                return Row(
                  children: [
                    if (index != 0)
                      SizedBox(width: AppDimensions.compactButtonPadding),
                    CompactButton(
                      child: SizedBox.shrink(),
                      onPressed: () async {},
                      backgroundColor: color,
                      foregroundColor: Colors.black,
                      borderSide: BorderSide(
                        color: AppColors.grey,
                      ),
                    ),
                    if (index == lastIndex)
                      SizedBox(width: AppDimensions.compactButtonPadding),
                    if (index == lastIndex)
                      CompactButton(
                        child: Text('Random'),
                        onPressed: () async {},
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        borderSide: BorderSide(
                          color: AppColors.grey,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
