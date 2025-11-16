import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/utils/extensions.dart';
import '../../blocs/camera_cubit/camera_cubit.dart';

class CameraImageSelectedSectionWidget extends StatelessWidget {
  const CameraImageSelectedSectionWidget({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.file(
            width: context.getWidth,
            height: context.getHeight,
            File(imagePath),
          ),
        ),
        Positioned(
          top: 20.h,
          right: 16.w,
          child: IconButton(
            icon: Icon(Icons.close, size: 32.sp, color: Colors.black),
            onPressed: () {
              context.read<CameraCubit>().initCamera();
            },
          ),
        ),
      ],
    );
  }
}
