import 'dart:math';

import 'package:carbon_intensity_dashboard/data/models/carbon_intensity_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../styles/colors.dart';
import '../styles/text.dart';

class CarbonIntensityChart extends StatelessWidget {
  final List<HalfHourlyIntensity> intensities;
  const CarbonIntensityChart({
    required this.intensities,
    super.key,
  });

  Color getBarColor(double intensity) {
    if (intensity <= 100) return AppColors.mainGreen;
    if (intensity <= 200) return AppColors.mainYellow;
    if (intensity <= 300) return AppColors.mainCoral;
    return AppColors.mainTextColor;
  }

  @override
  Widget build(BuildContext context) {
    final maxY = (intensities.map((e) => e.intensity).reduce(max).toDouble());

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;
        final labelInterval = (chartWidth / 50).floor();

        Widget bottomTitleWidgets(double value, TitleMeta meta) {
          final index = value.toInt();
          if (index % labelInterval == 0 ||
              index == intensities.length - 1 ||
              index == 0) {
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 6,
              child: Text(
                DateFormat('ha').format(intensities[index].time),
                style: AppTextStyle.black10Medium500,
              ),
            );
          }
          return const SizedBox.shrink();
        }

        Widget rightTitleWidgets(double value, TitleMeta meta) {
          return Text(
            '${value.toInt()}',
            style: AppTextStyle.black10Medium500,
            textAlign: TextAlign.right,
          );
        }

        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('kCO₂', style: AppTextStyle.black16Medium500),
              const SizedBox(height: 4),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    alignment: BarChartAlignment.spaceBetween,
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: maxY > 100 ? 100 : maxY / 2,
                          reservedSize: 22,
                          getTitlesWidget: rightTitleWidgets,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTitlesWidget: bottomTitleWidgets,
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: AppColors.mainTextColor,
                        strokeWidth: 0.1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: intensities.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: data.intensity.toDouble(),
                            color: getBarColor(data.intensity.toDouble()),
                            width: 5,
                            borderRadius: BorderRadius.zero,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
