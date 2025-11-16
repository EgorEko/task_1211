import 'package:camera/camera.dart';

enum CameraLens { rear, front }

class CameraService {
  CameraController? controller;
  List<CameraDescription> _availableCameras = [];

  CameraDescription? _selectCameraDescription(CameraLens lens) {
    final cameraSelector = lens == CameraLens.front
        ? CameraLensDirection.front
        : CameraLensDirection.back;

    try {
      return _availableCameras.firstWhere(
        (description) => description.lensDirection == cameraSelector,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> init(CameraLens initialLens) async {
    if (_availableCameras.isEmpty) {
      _availableCameras = await availableCameras();
    }

    final selectedCamera = _selectCameraDescription(initialLens);

    if (selectedCamera == null) {
      throw Exception('The selected lens is not available.');
    }

    await controller?.dispose();

    controller = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: true,
    );
    await controller!.initialize();
  }

  void dispose() {
    controller?.dispose();
    controller = null;
  }
}
