import 'package:flutter/material.dart';
import 'package:ucc_quiz_portal/core/utils/extensions.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PageIndicator(
      {super.key, required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: i == currentIndex ? 24 : 8,
            height: 6,
            margin: EdgeInsets.only(right: i == count - 1 ? 0 : 8),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: i == currentIndex
                  ? context.colorScheme.primary
                  : context.colorScheme.primary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              // shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
