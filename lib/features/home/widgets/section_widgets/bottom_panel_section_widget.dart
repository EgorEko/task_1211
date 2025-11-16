import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/utils/extensions.dart';
import '../../blocs/camera_cubit/camera_cubit.dart';
import '../../blocs/overlay_cubit/custom_overlay_cubit.dart';
import '../buttons/icon_button_widget.dart';
import '../buttons/video_record_button_widget.dart';

class BottomPanelSectionWidget extends StatelessWidget {
  const BottomPanelSectionWidget({
    super.key,
    required this.buttonAction,
    required this.isRecording,
  });

  final VoidCallback buttonAction;
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.h,
      child: SizedBox(
        width: context.getWidth,
        child: Row(
          children: [
            IconButtonWidget(
              onPressed: () => context.read<CameraCubit>().switchCamera(),
              icon: Icons.redo,
            ),
            IconButtonWidget(
              onPressed: () =>
                  context.read<CustomOverlayCubit>().pickOverlayImage(),
              icon: Icons.add_circle_outline,
            ),
            Spacer(flex: 2),
            VideoRecordButtonWidget(
              onTap: buttonAction,
              isRecording: isRecording,
            ),
            Spacer(flex: 2),
            IconButtonWidget(
              onPressed: () => context.read<CameraCubit>().takePicture(),
              icon: Icons.image_outlined,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
