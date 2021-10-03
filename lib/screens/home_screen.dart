import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hackdfw_app/models/esg_data.dart';
import 'package:hackdfw_app/screens/portfolio_screen.dart';
import 'package:hackdfw_app/stock_viewer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'aboout_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  FirstScreen createState() => FirstScreen();
}

class FirstScreen extends State<HomePage> {
  String predictionMessage = 'No Prediction';

  var random = Random();

  List<ESGData> _chartData = [];

  @override
  void initState() {
    _chartData = [
      ESGData('Environmental', randInt(30, 100), Color(0x410F57)),
      ESGData('Governmental', randInt(30, 100), Color(0x027333)),
      ESGData('Social', randInt(30, 100), Color(0xF2CD32)),
      ESGData('Total', randInt(30, 100), Color(0xE74236))
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Image.asset('assets/equitree-beige.png', height: 75),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()));
                },
                child: Text('About ESG',
                    style: TextStyle(color: Color(0xffF8F7E3)))),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SecondScreen()));
                },
                child: Text('Portfolio Evaluator',
                    style: TextStyle(color: Color(0xffF8F7E3)))),
          ]),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 600,
              width: 600,
              child: SfCircularChart(series: <CircularSeries>[
                RadialBarSeries<ESGData, String>(
                    dataSource: _chartData,
                    pointColorMapper: (ESGData data, _) => data.pointColor,
                    xValueMapper: (ESGData data, _) => data.category,
                    yValueMapper: (ESGData data, _) => data.score,
                    maximumValue: 100,
                    cornerStyle: CornerStyle.bothCurve)
              ])),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Environmental.\nSocial.\nGovernance.',
                    style:
                        TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                Text(
                    'Make your portfolio the\nchange you want to see in\nthe world.',
                    style:
                        TextStyle(fontSize: 36, fontWeight: FontWeight.normal))
              ])
        ],
      ),
    );
  }

  int randInt(int min, int max) {
    return min + random.nextInt(max - min);
  }
}
