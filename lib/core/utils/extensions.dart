import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;

  double get width => size.width;

  double get height => size.height;

  EdgeInsets get padding => mediaQuery.padding;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  NavigatorState get navigator => Navigator.of(this);

  void showSnackBar(String message, {bool isError = false}) =>
      ScaffoldMessenger.of(this)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content: Text(message,
                style: textTheme.bodyLarge?.copyWith(
                    color: isError ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold)),
            backgroundColor: isError ? Colors.red : Colors.green));
}
