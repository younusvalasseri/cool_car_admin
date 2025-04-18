import 'package:cool_car_admin/providers/providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Widgets/cool_car_app_bar.dart';

class CoolCarRevenuePage extends ConsumerWidget {
  const CoolCarRevenuePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revenueData = ref.watch(revenueProvider);

    return Scaffold(
      appBar: CoolCarAppBar(customTitle: 'Revenue Overview', showIcons: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: revenueData.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: Text("No revenue data available"));
            }

            final List<BarChartGroupData> barGroups = [];
            final List<String> monthYearLabels = [];

            int index = 0;
            for (var entry in data.entries) {
              barGroups.add(
                BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value,
                      color: Colors.blue,
                      width: 60,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ],
                  barsSpace: 0,
                ),
              );
              monthYearLabels.add(entry.key); // Store formatted Month-Year
              index++;
            }

            return Column(
              children: [
                const Text(
                  "Monthly Revenue",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 350, // ✅ Increased height for better view
                  child: BarChart(
                    BarChartData(
                      barGroups: barGroups,
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  "₹${data.values.elementAt(value.toInt()).toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  monthYearLabels[value.toInt()],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipPadding: const EdgeInsets.all(6),
                          tooltipRoundedRadius: 6,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              "₹${rod.toY.toStringAsFixed(2)}",
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("Error: $err")),
        ),
      ),
    );
  }
}
