import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/common/utils/extensions.dart';
import '../../blocs/camera_cubit/camera_cubit.dart';

class VideoRecordedSectionWidget extends StatelessWidget {
  const VideoRecordedSectionWidget({super.key, required this.videoController});

  final VideoPlayerController videoController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: context.getWidth,
          height: context.getHeight,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: videoController.value.size.width,
              height: videoController.value.size.height,
              child: VideoPlayer(videoController),
            ),
          ),
        ),
        Positioned(
          top: 20.h,
          right: 16.w,
          child: IconButton(
            icon: Icon(Icons.close, size: 32.sp, color: Colors.red),
            onPressed: () {
              context.read<CameraCubit>().initCamera();
            },
          ),
        ),
      ],
    );
  }
}
