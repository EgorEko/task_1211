import 'package:flutter/material.dart';

import '../../../core/common/utils/extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        centerTitle: false,
        toolbarHeight: context.getHeight * 0.11,
        title: Text(
          'Camera test task',
          style: AppTextStyles.appBarPrimary.copyWith(color: AppColors.black),
        ),
      ),
    );
  }
}
