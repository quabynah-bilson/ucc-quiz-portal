import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ucc_quiz_portal/core/utils/dialogs.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStack extends StatefulWidget with WidgetsBindingObserver {
  final int loadingPercentage;

  const WebViewStack(
      {required this.controller,
      required this.loadingPercentage,
      super.key}); // MODIFY

  final WebViewController controller; // ADD

  @override
  State<WebViewStack> createState() => WebViewStackState();
}

class WebViewStackState extends State<WebViewStack> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(), () => showExitAttemptSheet(context));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          WebViewWidget(controller: widget.controller),
          if (widget.loadingPercentage < 100)
            LinearProgressIndicator(
              value: widget.loadingPercentage / 100.0,
            ),
        ],
      );
}
