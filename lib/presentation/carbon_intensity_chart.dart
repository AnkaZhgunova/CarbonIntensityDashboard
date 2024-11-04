import 'package:carbon_intensity_dashboard/data/models/carbon_intensity_model.dart';
import 'package:carbon_intensity_dashboard/styles/colors.dart';
import 'package:carbon_intensity_dashboard/styles/text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarbonIntensityChart extends StatelessWidget {
  final List<HalfHourlyIntensity> intensities;

  const CarbonIntensityChart({super.key, required this.intensities});

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    if (value % 20 == 0 && value == 0) return const SizedBox.shrink();
    if (value % 20 == 0) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text(value.toInt().toString(),
            style: AppTextStyle.black10Medium500),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    final index = value.toInt();

    if (index == 0) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 5,
        child: Text(
          DateFormat('HH:mm').format(intensities.first.time),
          style: AppTextStyle.black10Medium500,
        ),
      );
    } else if (index == intensities.length - 1) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 5,
        child: Text(
          DateFormat('HH:mm').format(intensities.last.time),
          style: AppTextStyle.black10Medium500,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          horizontalInterval: 20,
          verticalInterval: 1,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.steel.withOpacity(0.3),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: AppColors.steel.withOpacity(0.3),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppColors.steel, width: 1),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: const SizedBox(),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: _bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20,
              getTitlesWidget: _leftTitleWidgets,
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: intensities
                .asMap()
                .entries
                .map(
                  (entry) => FlSpot(
                    entry.key.toDouble(),
                    entry.value.intensity.toDouble(),
                  ),
                )
                .toList(),
            isCurved: true,
            color: AppColors.steel,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 2,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: AppColors.steel,
                );
              },
              checkToShowDot: (spot, barData) =>
                  spot.x == intensities.length - 1,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.steel.withOpacity(0.3),
                  AppColors.steel.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: const LineTouchData(enabled: false),
      ),
    );
  }
}
