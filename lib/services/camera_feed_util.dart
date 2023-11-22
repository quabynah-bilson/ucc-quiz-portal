import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucc_quiz_portal/core/utils/extensions.dart';
import 'package:ucc_quiz_portal/core/utils/logs.dart';
import 'package:video_compress/video_compress.dart';

/// Utility class for camera feed related operations
/// 1. capture camera feed
/// 2. save to device cache directory
/// 3. upload to firebase storage
/// 4. get download url
/// 5. save to firestore
final class CameraFeedUtil {
  CameraFeedUtil({required this.controller, required this.context});

  final CameraController controller;
  final BuildContext context;

  File? _videoFile;

  /// Start recording a video from the camera feed
  Future startRecordingSession() async {
    if (_videoFile != null) await _videoFile?.delete();
    await _startRecording();
  }

  /// Stop recording a video from the camera feed
  Future stopRecordingSession() async => _stopRecording();

  /// take random pictures from the camera feed within a specified duration
  Future<void> _takeRandomPictures(
      [Duration duration = const Duration(minutes: 5)]) async {
    try {
      var timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
        var xFile = await controller.takePicture();
        logger.i('Picture taken: ${xFile.path}');
        // @todo -> upload picture to firebase storage
      });

      await Future.delayed(duration);
      timer.cancel();
    } catch (e) {
      logger.e('Error taking random pictures: $e');
    }
  }

  // start recording video from camera feed
  Future<void> _startRecording() async {
    try {
      await controller.startVideoRecording();
    } catch (e) {
      logger.e('Error starting video recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    // check if camera is recording
    if (!controller.value.isRecordingVideo) return;

    // stop recording
    try {
      var xFile = await controller.stopVideoRecording();
      _videoFile = File(xFile.path);
    } catch (e) {
      logger.e('Error stopping video recording: $e');
      return;
    }

    // request user index number
    var indexNumber = await captureUserIndexNumber();

    if (indexNumber != null) {
      // compress video
      var compressedVideo = await _compressVideo(_videoFile!);

      // upload video to firebase storage
      var downloadUrl =
          await _uploadFeedToFirebaseStorage(indexNumber, compressedVideo!);

      // save feed to firestore
      await _saveFeedToFirestore(indexNumber, downloadUrl!);
    }
  }

  Future<Uint8List?> _compressVideo(File videoFile) async {
    try {
      var compressedVideo = await VideoCompress.compressVideo(videoFile.path,
          quality: VideoQuality.Res1920x1080Quality, deleteOrigin: true);
      return compressedVideo?.file?.readAsBytes();
    } catch (e) {
      logger.e('Error compressing video: $e');
      return null;
    }
  }

  Future<String?> captureUserIndexNumber() async {
    final formKey = GlobalKey<FormState>(),
        indexNumberController = TextEditingController();

    var indexNumber = await showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: context.colorScheme.background,
      builder: (context) => Material(
        type: MaterialType.transparency,
        color: context.colorScheme.background,
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(24, 24, 24, context.padding.bottom + 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('One more step',
                    style: context.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                    'If you are done with the quiz, enter your index number for confirmation',
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                TextFormField(
                  controller: indexNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your index number';
                    }
                    return null;
                  },
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (value) {
                    if (formKey.currentState != null &&
                        formKey.currentState!.validate()) {
                      formKey.currentState?.save();
                      context.navigator.pop(value);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Index Number',
                    hintText: 'Enter your index number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    formKey.currentState?.reset();
    await controller.dispose();
    if (indexNumber is String) return indexNumber;
    return null;
  }

  Future<String?> _uploadFeedToFirebaseStorage(
      String indexNumber, Uint8List videoFile) async {
    try {
      var reference =
          FirebaseStorage.instance.ref().child('videos/$indexNumber.mp4');
      var uploadTask = reference.putData(videoFile);
      var snapshot = await uploadTask.whenComplete(() => null);
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      logger.e('Error uploading video to firebase storage: $e');
      return null;
    }
  }

  Future<void> _saveFeedToFirestore(
      String indexNumber, String downloadUrl) async {
    try {
      var collection = FirebaseFirestore.instance
          .collection('quiz-feeds/$indexNumber/sessions');
      await collection.add({
        'index_number': indexNumber,
        'download_url': downloadUrl,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      logger.e('Error saving feed to firestore: $e');
    }
  }
}
