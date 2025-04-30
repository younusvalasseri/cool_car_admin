import 'package:cool_car_admin/Widgets/app_colors.dart';
import 'package:flutter/material.dart';

class AdminCard extends StatelessWidget {
  final String title;
  final bool isFullWidth;
  final Widget? child;
  final VoidCallback? onTap;

  const AdminCard({
    super.key,
    required this.title,
    this.isFullWidth = false,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
