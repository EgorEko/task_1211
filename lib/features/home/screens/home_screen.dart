import 'dart:developer';
import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../core/common/utils/extensions.dart';
import '../../../core/common/utils/formater.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../permisions/utils/camera_service.dart';
import '../blocs/camera_cubit/camera_cubit.dart';
import '../blocs/camera_cubit/camera_state.dart';
import '../blocs/overlay_cubit/custom_overlay_cubit.dart';
import '../widgets/icon_button_widget.dart';
import '../widgets/video_record_button_widget.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CameraService _cameraService;

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              CameraCubit(cameraService: _cameraService)..initCamera(),
        ),
        BlocProvider(create: (_) => CustomOverlayCubit()),
      ],
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer(VideoRecorded state) async {
    await _videoController?.dispose();

    final videoFile = File(state.videoFile.path);

    _videoController = VideoPlayerController.file(videoFile);

    try {
      await _videoController!.initialize();
      if (mounted) {
        _videoController!.setLooping(true);
        _videoController!.play();
        setState(() {});
      }
    } catch (e) {
      log('Error initializing video player: $e');
    }
  }

  void _clearVideoPlayer() {
    _videoController?.dispose();
    _videoController = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CameraCubit, CameraState>(
      listener: (context, state) {
        if (state is VideoRecorded) {
          _initializeVideoPlayer(state);
        } else if (state is CameraReady) {
          _clearVideoPlayer();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          centerTitle: false,
          toolbarHeight: context.getHeight * 0.11,
          flexibleSpace: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, bottom: 4.h),
              child: Text(
                'Camera test task',
                style: AppTextStyles.appBarPrimary.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<CameraCubit, CameraState>(
          builder: (context, state) {
            if (state is CameraLoading || state is CameraInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CameraError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text('Error: ${state.message}'),
                ),
              );
            }
            if (state is CameraImageSelected) {
              return Stack(
                children: [
                  Center(
                    child: Image.file(
                      width: context.getWidth,
                      height: context.getHeight,
                      File(state.imageFile.path),
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
            if (state is VideoRecorded) {
              if (_videoController == null ||
                  !_videoController!.value.isInitialized) {
                return const Center(child: CircularProgressIndicator());
              }
              return Stack(
                children: [
                  SizedBox(
                    width: context.getWidth,
                    height: context.getHeight,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoController!.value.size.width,
                        height: _videoController!.value.size.height,
                        child: VideoPlayer(_videoController!),
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
            if (state case CameraReady() || RecordingInProgress()) {
              late final CameraController controller;
              Duration? duration;

              if (state is CameraReady) {
                controller = state.controller;
              } else if (state is RecordingInProgress) {
                controller = state.controller;
                duration = state.duration;
              }
              final cubit = context.read<CameraCubit>();
              final bool isRecording = state is RecordingInProgress;
              void buttonAction() {
                if (isRecording) {
                  cubit.stopRecording();
                } else {
                  cubit.startRecording();
                }
              }

              return Stack(
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: context.getWidth,
                        height: context.getWidth * controller.value.aspectRatio,
                        child: CameraPreview(controller),
                      ),
                    ),
                  ),
                  BlocBuilder<CustomOverlayCubit, CustomOverlayState>(
                    builder: (context, overlayState) {
                      if (overlayState.image == null) {
                        return const SizedBox.shrink();
                      }
                      return Positioned.fill(
                        child: Opacity(
                          opacity: 0.2,
                          child: Image.file(
                            overlayState.image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  if (isRecording)
                    Positioned(
                      top: 20.h,
                      right: 16.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 18.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            4.horizontalSpace,
                            Text(
                              duration != null
                                  ? Formater.formatDuration(duration)
                                  : '',
                              style: AppTextStyles.timer.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 16.h,
                    child: SizedBox(
                      width: context.getWidth,
                      child: Row(
                        children: [
                          IconButtonWidget(
                            onPressed: () =>
                                context.read<CameraCubit>().switchCamera(),
                            icon: Icons.redo,
                          ),
                          IconButtonWidget(
                            onPressed: () => context
                                .read<CustomOverlayCubit>()
                                .pickOverlayImage(),
                            icon: Icons.add_circle_outline,
                          ),
                          Spacer(flex: 2),
                          VideoRecordButtonWidget(
                            onTap: buttonAction,
                            isRecording: isRecording,
                          ),
                          Spacer(flex: 2),
                          IconButtonWidget(
                            onPressed: () =>
                                context.read<CameraCubit>().takePicture(),
                            icon: Icons.image_outlined,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
