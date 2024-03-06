import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StudentMarksChart extends StatelessWidget {
  // Define three lists of chart data
  final List<List<ChartData>> dataOptions = [
    [
      ChartData('Sem 1', 70),
      ChartData('Sem 2', 75),
      ChartData('Sem 3', 80),
      ChartData('Sem 4', 85),
      ChartData('Sem 5', 90),
      ChartData('Sem 6', 95),
      ChartData('Sem 7', 92),
    ],
    [
      ChartData('Sem 1', 65),
      ChartData('Sem 2', 68),
      ChartData('Sem 3', 72),
      ChartData('Sem 4', 80),
      ChartData('Sem 5', 85),
      ChartData('Sem 6', 90),
      ChartData('Sem 7', 92),
    ],
    // Define more lists as needed
  ];

  StudentMarksChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Randomly select one of the data options
    final random = Random();
    final List<ChartData> chartData = dataOptions[random.nextInt(dataOptions.length)];

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Marks Progress'),
      ),
      body: Center(
        child: Container(
          height: 300,
          padding: EdgeInsets.all(16.0),
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <CartesianSeries>[
              LineSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.semester,
                yValueMapper: (ChartData data, _) => data.marks,
                markerSettings: MarkerSettings(
                  isVisible: true,
                ),
              ),
            ],
            tooltipBehavior: TooltipBehavior(enable: true),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final String semester;
  final double marks;

  ChartData(this.semester, this.marks);
}
