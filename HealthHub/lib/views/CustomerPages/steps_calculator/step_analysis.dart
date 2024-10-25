import 'dart:collection';

import 'package:bgmfitness/Models/step_model.dart';
import 'package:bgmfitness/services/step_services.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StepAnalysisScreen extends StatefulWidget {
  const StepAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<StepAnalysisScreen> createState() => _StepAnalysisScreenState();
}

class _StepAnalysisScreenState extends State<StepAnalysisScreen> {
  List<_SalesData> data = [];
  StepService _stepService = StepService();
  String start2 = '';
  String? temp = '';
  int max = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      // appBar: AppBar(backgroundColor: Color( 0xffF79916),title: Text('Health')),
      body: SafeArea(child: _buildBody(context)),
    );
  }
  // List<_SalesData> data = [
  //   _SalesData('Jan', 35),
  //   _SalesData('Feb', 28),
  //   _SalesData('Mar', 34),
  //   _SalesData('Apr', 32),
  //   _SalesData('May', 80),
  //   _SalesData('May', 90),
  // ];

  Widget _buildBody(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          //Initialize the chart widget
          Expanded(
            child: StreamBuilder<StepsModel?>(
                stream: _stepService.getSteps(),
                builder: (BuildContext context, stepData) {
                  if (stepData.hasError) {
                    return Center(
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator()),
                    );
                  }
                  if (!stepData.hasData) {
                    return Center(
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator()),
                    );
                  }
                  print('health');
                  print(stepData.data!.stepsData.length);
                  int len = stepData.data!.stepsData.length;
                  for (int i = stepData.data!.stepsData.length - 1;
                      i >= 0;
                      i--) {
                    if (temp != stepData.data!.stepsData[i]['date']) {
                      for (int j = 0; j < len; j++) {
                        if (stepData.data!.stepsData[i]['date'] ==
                            stepData.data!.stepsData[j]['date']) {
                          max = int.parse(stepData.data!.stepsData[j]['steps']);
                        }
                      }
                      temp = stepData.data!.stepsData[i]['date'];

                      // data.add(_SalesData(stepData.data!.stepsData[i]['date'], max));
                      data.add(_SalesData(temp, max));
                    }

                    // max=temp.reduce((curr, next) => curr > next? curr: next);
                    // print(max);
                    // if(stepData.data!.stepsData.length>0){
                    //   data.add(_SalesData(stepData.data!.stepsData[i]['date'], int.parse(stepData.data!.stepsData[i]['steps'])));
                    // }
                  }
                  // print(data[0].sales);
                  start2 = 'j';

                  print(data.toSet().toList());
                  return SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        arrangeByIndex: false,
                        maximum: 6.5,
                        labelStyle: TextStyle(fontSize: 8),

                        // autoScrollingMode: AutoScrollingMode.start
                      ),
                      // Chart title
                      title: ChartTitle(text: 'Weekly Steps Analysis'),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<_SalesData, String>>[
                        ColumnSeries(
                            // width: 0.5,
                            dataSource: data,

                            // initialSelectedDataIndexes: <int>[0],
                            xValueMapper: (_SalesData sales, _) => sales.year,
                            yValueMapper: (_SalesData sales, _) => sales.sales,
                            name: 'Steps',
                            color: Colors.black,
                            xAxisName: 'Date',
                            yAxisName: 'Steps',
                            // Enable data label
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside,
                                // showCumulativeValues: true,
                                // useSeriesColor: true,
                                // labelIntersectAction: LabelIntersectAction.hide,
                                labelAlignment: ChartDataLabelAlignment.auto,
                                textStyle: TextStyle(
                                    color: Colors.black, fontSize: 14)))
                      ]);
                }),
          ),
        ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String? year;
  final int sales;
}
