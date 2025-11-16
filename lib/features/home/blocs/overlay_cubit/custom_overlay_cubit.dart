import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'custom_overlay_state.dart';

class CustomOverlayCubit extends Cubit<CustomOverlayState> {
  final ImagePicker _picker = ImagePicker();

  CustomOverlayCubit() : super(const CustomOverlayState());

  Future<void> pickOverlayImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      emit(CustomOverlayState(image: File(picked.path)));
    }
  }

  void removeOverlay() => emit(const CustomOverlayState(image: null));
}
