import 'package:flutter/material.dart';
import 'package:ucc_quiz_portal/core/utils/constant.dart';
import 'package:ucc_quiz_portal/core/utils/extensions.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AppButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          constraints: BoxConstraints(maxWidth: context.width * 0.85),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: BorderRadius.circular(kDefaultRadius),
          ),
          child: Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
