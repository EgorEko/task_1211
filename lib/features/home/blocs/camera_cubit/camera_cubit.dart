import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../permisions/utils/camera_service.dart';
import 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit({required CameraService cameraService})
    : _cameraService = cameraService,
      super(CameraInitial());

  final CameraService _cameraService;

  CameraLens _currentLens = CameraLens.rear;
  Timer? _timer;
  Duration _duration = Duration.zero;

  Future<void> initCamera() async {
    emit(CameraLoading());

    try {
      await _cameraService.init(_currentLens);

      final controller = _cameraService.controller!;
      emit(CameraReady(controller: controller, currentLens: _currentLens));
    } catch (e) {
      emit(CameraError(message: 'Camera initialization error: $e'));
    }
  }

  Future<void> switchCamera() async {
    _currentLens = _currentLens == CameraLens.rear
        ? CameraLens.front
        : CameraLens.rear;

    await initCamera();
  }

  Future<void> takePicture() async {
    if (state is! CameraReady) return;

    final controller = (state as CameraReady).controller;

    try {
      emit(CameraLoading());

      final file = await controller.takePicture();
      emit(CameraImageSelected(imageFile: file));
    } catch (e) {
      emit(CameraError(message: 'Capture error: $e'));
    }
  }

  Future<void> startRecording() async {
    if (state is! CameraReady) return;

    final controller = (state as CameraReady).controller;

    try {
      await controller.startVideoRecording();
      _duration = Duration.zero;

      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        _duration += const Duration(seconds: 1);

        emit(
          RecordingInProgress(
            controller: controller,
            currentLens: _currentLens,
            duration: _duration,
            isPaused: controller.value.isRecordingPaused,
          ),
        );
      });
    } catch (e) {
      emit(CameraError(message: 'Start recording error: $e'));
    }
  }

  Future<void> stopRecording() async {
    if (state is! RecordingInProgress) return;

    _timer?.cancel();

    final controller = (state as RecordingInProgress).controller;

    try {
      final file = await controller.stopVideoRecording();
      emit(VideoRecorded(videoFile: file));
    } catch (e) {
      emit(CameraError(message: 'Stop error: $e'));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _cameraService.dispose();
    return super.close();
  }
}
