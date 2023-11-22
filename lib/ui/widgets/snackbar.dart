import 'package:flutter/material.dart';

showSnackBar(BuildContext? context, Widget? content, backgroundColor) {
  return ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      content: content!,
      backgroundColor: backgroundColor,
    ),
  );
}
