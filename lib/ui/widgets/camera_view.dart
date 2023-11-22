import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ucc_quiz_portal/core/utils/logs.dart';

class CameraView extends StatefulWidget {
  final bool startCameraPreview;
  final VoidCallback onPermissionDenied;
  final Function(CameraController) onCameraControllerInitialized;

  const CameraView({
    super.key,
    required this.onPermissionDenied,
    this.startCameraPreview = false,
    required this.onCameraControllerInitialized,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  var _cameras = List<CameraDescription>.empty(growable: true),
      _isCameraAvailable = false;
  CameraController? _cameraController;
  late final _avatarSize = MediaQuery.of(context).size.width * 0.08;
  late final _colorScheme = Theme.of(context).colorScheme;

  Widget get _buildCameraPreview => Container(
        width: _avatarSize,
        height: _avatarSize,
        margin: const EdgeInsets.only(right: 16),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_avatarSize),
          border: Border.all(color: _colorScheme.onBackground, width: 2),
        ),
        child: CameraPreview(_cameraController!),
      );

  @override
  void initState() {
    super.initState();
    _setupCameras();
  }

  @override
  void dispose() async {
    // await _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CameraView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startCameraPreview != widget.startCameraPreview) {
      logger.i('camera preview changed');
      _setupCameras();
    }
  }

  @override
  Widget build(BuildContext context) =>
      _isCameraAvailable ? _buildCameraPreview : const SizedBox.shrink();

  void _setupCameras() async {
    if (!mounted) return;

    // check if the camera preview is required
    if (!widget.startCameraPreview) return;

    // check for the number of available cameras on the device
    _cameras = await availableCameras();

    try {
      if (_cameras.isEmpty) {
        widget.onPermissionDenied.call();
        return;
      }

      // get the front camera if available
      var frontCamera = _cameras.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.front);

      _cameraController = CameraController(frontCamera, ResolutionPreset.low);
      _isCameraAvailable = true;
      await _cameraController?.initialize();
      if (_cameraController == null) return;
      widget.onCameraControllerInitialized.call(_cameraController!);
    } catch (e) {
      logger.e('an error occurred while setting up the camera -> $e');
      _isCameraAvailable = false;
    }
    setState(() {});
  }
}
