import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_colors.dart';
import 'features/home/screens/home_screen.dart';

class CameraTestTaskApp extends StatelessWidget {
  const CameraTestTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(395, 812),
      child: MaterialApp(
        title: 'Camera test task',
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.white,
          ),
          fontFamily: 'Inter',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
