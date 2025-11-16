import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

class VideoRecordButtonWidget extends StatelessWidget {
  const VideoRecordButtonWidget({
    super.key,
    required this.onTap,
    required this.isRecording,
  });

  final VoidCallback onTap;
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r / 2),
      child: Container(
        width: 70.r,
        height: 70.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: AppColors.white, width: 3.r),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isRecording ? 20.r : 60.r,
          height: isRecording ? 20.r : 60.r,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(isRecording ? 4.r : 60.r / 2),
          ),
        ),
      ),
    );
  }
}
