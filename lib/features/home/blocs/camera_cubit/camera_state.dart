import 'package:camera/camera.dart';

import '../../../permisions/utils/camera_service.dart';

abstract class CameraState {}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraReady extends CameraState {
  CameraReady({required this.controller, required this.currentLens});

  final CameraController controller;
  final CameraLens currentLens;
}

class CameraImageSelected extends CameraState {
  CameraImageSelected({required this.imageFile});

  final XFile imageFile;
}

class RecordingInProgress extends CameraState {
  RecordingInProgress({
    required this.controller,
    required this.currentLens,
    required this.duration,
    this.isPaused = false,
  });

  final CameraController controller;
  final CameraLens currentLens;
  final Duration duration;
  final bool isPaused;
}

class VideoRecorded extends CameraState {
  VideoRecorded({required this.videoFile});

  final XFile videoFile;
}

class CameraError extends CameraState {
  CameraError({required this.message});

  final String message;
}
