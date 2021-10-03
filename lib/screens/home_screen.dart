import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hackdfw_app/models/gdp_data.dart';
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

  List<GDPData> _chartData = [];

  @override
  void initState() {
    _chartData = [
      GDPData('Environmental', randInt(30, 100), Color(0x410F57)),
      GDPData('Governmental', randInt(30, 100), Color(0x027333)),
      GDPData('Social', randInt(30, 100), Color(0xF2CD32)),
      GDPData('Total', randInt(30, 100), Color(0xE74236))
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
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => StockViewer()));
                },
                child: Text('Stock Viewer',
                    style: TextStyle(color: Color(0xffF8F7E3)))),
          ]),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 600,
              width: 600,
              child: SfCircularChart(
                  // annotations: <CircularChartAnnotation>[
                  //   CircularChartAnnotation(
                  //       widget: Container(
                  //           child: Text(_chartData[3].gdp.toString(), style: TextStyle(fontSize: 36, fontWeight: FontWeight.normal))
                  //       ),
                  //       radius: '0%',
                  //   )
                  // ],
                  series: <CircularSeries>[
                    RadialBarSeries<GDPData, String>(
                        dataSource: _chartData,
                        pointColorMapper: (GDPData data, _) => data.pointColor,
                        xValueMapper: (GDPData data, _) => data.continent,
                        yValueMapper: (GDPData data, _) => data.gdp,
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
      // floatingActionButton: FloatingActionButton.extended(
      //     onPressed: () {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => SecondScreen()));
      //     },
      //     label: const Text('Go to Graph Page')),
    );
  }

  int randInt(int min, int max) {
    return min + random.nextInt(max - min);
  }
}
