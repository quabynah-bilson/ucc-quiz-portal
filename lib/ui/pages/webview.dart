import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ucc_quiz_portal/core/utils/logs.dart';
import 'package:ucc_quiz_portal/services/camera_feed_util.dart';
import 'package:ucc_quiz_portal/ui/widgets/camera_view.dart';
import 'package:ucc_quiz_portal/ui/widgets/navigation_controls.dart';
import 'package:ucc_quiz_portal/ui/widgets/webview_stack.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);
  var _toggleCameraPreview = false, _loadingPercentage = 0;
  CameraFeedUtil? _cameraFeedUtil;

  // ActiveState activeState = ActiveState();
  @override
  void initState() {
    super.initState();
    // activeState.initialise();

    enableKioskMode();
    _loadUrl();
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: (enabled) {},
        child: Scaffold(
          appBar: AppBar(
            title: const Text('UCC E-Learning',
                style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              if (!_toggleCameraPreview) ...{
                NavigationControls(controller: _controller),
              },
              CameraView(
                startCameraPreview: _toggleCameraPreview,
                onPermissionDenied: _handlePermissionDenied,
                onCameraControllerInitialized: (controller) => _cameraFeedUtil =
                    CameraFeedUtil(context: context, controller: controller),
              ),
            ],
          ),
          body: WebViewStack(
              controller: _controller, loadingPercentage: _loadingPercentage),
          floatingActionButton: _toggleCameraPreview
              ? FloatingActionButton(
                  child: const Icon(Icons.video_chat),
                  onPressed: () async {
                    var id = await _cameraFeedUtil?.captureUserIndexNumber();
                    logger.i('ID: $id');
                    // @todo -> stop recording and upload data
                  },
                )
              : null,
        ),
      );

  void disableKioskMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  void enableKioskMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  void _loadUrl([String? url]) {
    _controller.loadRequest(
        Uri.parse(url ?? 'https://elearning.ucc.edu.gh/login/index.php'));
    _listenForUrlChanges();
  }

  void _listenForUrlChanges() => _controller.setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (url) async {
            setState(() => _loadingPercentage = 0);
            // log the url
            logger.i('url updated to -> ${url.url}');
            if (url.url == null) return;

            // https://elearning.ucc.edu.gh/mod/quiz/attempt.php?attempt
            var quizOrExamUrlRegex = RegExp(
                r'https:\/\/elearning\.ucc\.edu\.gh\/mod\/quiz\/attempt\.php\?attempt');
            _toggleCameraPreview = quizOrExamUrlRegex.hasMatch(url.url!);
            setState(() {});
            if (_toggleCameraPreview) {
              await _cameraFeedUtil?.startRecordingSession();
            }
          },
          onProgress: (progress) =>
              setState(() => _loadingPercentage = progress),
        ),
      );

  void _handlePermissionDenied() async {
    // @todo -> handle state when user denies camera permission
  }
}
