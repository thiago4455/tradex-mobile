import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tradex_mobile/core/models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tradex_mobile/core/utils.dart';

class PricingChart extends StatelessWidget {
  final List<Pricing> data;
  const PricingChart(this.data, {super.key});


  static List<Color> gradientColors = [
    Colors.purple.shade100,
    Colors.purple.shade900,
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        );
  }


  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    if(data.any((e) => e.price - 1 < value && value < e.price + 1))
    { text = value.toPrice();}
    else { text = ""; }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    var spots = data.map((e) => FlSpot(monthProgress(e.createdAt), e.price)).toList();
    spots.sort((a, b) => a.x.compareTo(b.x));
    double maxV = data.map((e) => e.price).reduce(max);
    double minV = data.map((e) => e.price).reduce(min);
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.purple,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.purple,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 100,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 12,
      minY: minV - minV/10,
      maxY: maxV + maxV/10,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}