import 'package:cool_car_admin/Widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TodayCountCard extends ConsumerWidget {
  final String label;
  final Stream<AsyncValue<int>> stream;
  final VoidCallback onTap;
  final bool isFullWidth;

  const TodayCountCard({
    super.key,
    required this.label,
    required this.stream,
    required this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<AsyncValue<int>>(
      stream: stream,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: isFullWidth ? double.infinity : null,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (!snapshot.hasData)
                  LinearPercentIndicator(
                    lineHeight: 6.0,
                    percent: 1.0,
                    animation: true,
                    backgroundColor: Colors.grey[300]!,
                    progressColor: Colors.blue,
                  )
                else
                  Text(
                    snapshot.data!.value.toString(),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
