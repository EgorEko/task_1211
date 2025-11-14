import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/router/router.dart';
import 'core/theme/app_colors.dart';

class CameraTestTaskApp extends StatelessWidget {
  CameraTestTaskApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(395, 812),
      child: MaterialApp.router(
        title: 'Camera test task',
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.white,
          ),
          fontFamily: 'Inter',
        ),
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
