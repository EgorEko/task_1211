import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'camera_test_task_app.dart';
import 'core/blocs/permission_cubit/permission_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => PermissionCubit())],
      child: CameraTestTaskApp(),
    ),
  );
}
