import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/blocs/permission_cubit/permission_cubit.dart';
import '../../../core/blocs/permission_cubit/permission_state.dart';
import '../../../core/common/utils/extensions.dart';
import '../../../core/router/router.dart';

class PermissionGuard extends StatelessWidget {
  const PermissionGuard({super.key});

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Permission required'),
        content: const Text(
          'Camera access is required to use the app\'s features. Open settings?',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              context.router.pop();
              context.read<PermissionCubit>().checkCameraPermission();
            },
          ),
          TextButton(
            child: const Text('Settings'),
            onPressed: () async {
              context.router.pop();
              await openAppSettings();
              if (context.mounted) {
                context.read<PermissionCubit>().checkCameraPermission();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PermissionCubit, PermissionState>(
      listener: (context, state) {
        if (state is PermissionGranted) {
          context.router.replace(const HomeRoute());
        } else if (state is PermissionPermanentlyDenied) {
          _showSettingsDialog(context);
        } else if (state is PermissionDenied) {
          context.showSnack('Camera permission not granted.');
        }
      },
      child: BlocBuilder<PermissionCubit, PermissionState>(
        builder: (context, state) {
          if (state is PermissionInitial || state is PermissionDenied) {
            if (state is PermissionInitial) {
              context.read<PermissionCubit>().checkCameraPermission();
            }
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Checking permissions...'),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
