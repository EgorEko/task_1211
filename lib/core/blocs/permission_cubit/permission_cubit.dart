import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit() : super(PermissionInitial());

  Future<void> checkCameraPermission() async {
    var status = await Permission.camera.status;

    if (status.isGranted) {
      emit(PermissionGranted());
    } else if (status.isDenied) {
      status = await Permission.camera.request();
      if (status.isGranted) {
        emit(PermissionGranted());
      } else if (status.isPermanentlyDenied) {
        emit(PermissionPermanentlyDenied());
      } else {
        emit(PermissionDenied());
      }
    } else if (status.isPermanentlyDenied) {
      emit(PermissionPermanentlyDenied());
    }
  }
}
