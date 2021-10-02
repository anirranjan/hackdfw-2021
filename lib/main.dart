import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackDFW Submission',
      home: HomePage(),
      debugShowCheckedModeBanner: false
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  FirstScreen createState() => FirstScreen();
}

class FirstScreen extends State<HomePage> {
  String testMessage = '';

  List<GDPData> _chartData = [
    GDPData('Environmental', 78, Color(0x410F57)),
    GDPData('Governmental', 50, Color(0x027333)),
    GDPData('Social', 62, Color(0xF2CD32)),
    GDPData('Average', 63, Color(0xE74236))
  ];
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TITLE'),
        actions: [
          FlatButton(
              textColor: Colors.white,
              onPressed: () {},
              child: Text('About ESG')
          ),
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen()));
            },
            child: Text('Portfolio Evaluator')
          ),
        ]
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 600,
            width: 600,
            child: SfCircularChart(
                tooltipBehavior: _tooltipBehavior,
                annotations: <CircularChartAnnotation>[
                  CircularChartAnnotation(
                      widget: Container(
                          child: Text(_chartData[3].gdp.toString())
                      ),
                      radius: '0%',
                  )
                ],
                series: <CircularSeries>[
                  RadialBarSeries<GDPData, String>(
                      dataSource: _chartData,
                      pointColorMapper: (GDPData data,_) => data.pointColor,
                      xValueMapper: (GDPData data,_) => data.continent,
                      yValueMapper: (GDPData data,_) => data.gdp,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      enableTooltip: true,
                      maximumValue: 2500,
                      cornerStyle: CornerStyle.bothCurve
                  )]
            )
          ),
          TextButton(
            onPressed: () async {
              var url = Uri.http("user:pass@localhost:5000", "");
              final response = await http.get(url);
              var jsonResponse =
              convert.jsonDecode(response.body) as Map<String, dynamic>;
              setState(() {
                _chartData = <GDPData>[];
                int e = jsonResponse['environmentalScore'];
                int s = jsonResponse['socialScore'];
                int g = jsonResponse['governanceScore'];
                int average = ((e+s+g)/3).floor();
                _chartData.add(GDPData('Environmental', e, Color(0x410F57)));
                _chartData.add(GDPData('Governmental', g, Color(0x027333)));
                _chartData.add(GDPData('Social', s, Color(0xF2CD32)));
                _chartData.add(GDPData('Average', average, Color(0xE74236)));
              });
            },
            child: Text('Get Data'),
          ),
          Column (
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Environmental.\nSocial.\nGovernance.',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
              Text('Make your portfolio the\nchange you want to see in\nthe world.',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.normal))
            ]
          )
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

  /// Get the random value.
  int _getRandomInt(int min, int max) {
    return min + random.nextInt(max - min);
  }

  /// Method to update the chart data.
  List<GDPData> _getChartData() {
    int e = _getRandomInt(1,100);
    int s = _getRandomInt(1,100);
    int g = _getRandomInt(1,100);
    int average = ((e+s+g)/3).floor();
    _chartData.add(GDPData('Environmental', e, Color(0x410F57)));
    _chartData.add(GDPData('Governmental', g, Color(0x027333)));
    _chartData.add(GDPData('Social', s, Color(0xF2CD32)));
    _chartData.add(GDPData('Average', average, Color(0xE74236)));
    return _chartData;
  }
}

class SecondScreen extends State<HomePage> {
  List<GDPData> _chartData = [
    GDPData('Environmental', 78, Color(0x410F57)),
    GDPData('Governmental', 50, Color(0x027333)),
    GDPData('Social', 62, Color(0xF2CD32)),
    GDPData('Average', 63, Color(0xE74236))
  ];
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('TITLE'),
          actions: [
            FlatButton(
                textColor: Colors.white,
                onPressed: () {},
                child: Text('About ESG')
            ),
            FlatButton(
                textColor: Colors.white,
                onPressed: () {},
                child: Text('Portfolio Evaluator')
            ),
          ]
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 600,
              width: 600,
              child: SfCircularChart(
                  tooltipBehavior: _tooltipBehavior,
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: Container(
                          child: Text(_chartData[3].gdp.toString())
                      ),
                      radius: '0%',
                    )
                  ],
                  series: <CircularSeries>[
                    RadialBarSeries<GDPData, String>(
                        dataSource: _chartData,
                        pointColorMapper: (GDPData data,_) => data.pointColor,
                        xValueMapper: (GDPData data,_) => data.continent,
                        yValueMapper: (GDPData data,_) => data.gdp,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        enableTooltip: true,
                        maximumValue: 2500,
                        cornerStyle: CornerStyle.bothCurve
                    )]
              )
          ),
          TextButton(
            onPressed: () async {
              var url = Uri.http("user:pass@localhost:5000", "");
              final response = await http.get(url);
              var jsonResponse =
              convert.jsonDecode(response.body) as Map<String, dynamic>;
              setState(() {
                _chartData = <GDPData>[];
                int e = jsonResponse['environmentalScore'];
                int s = jsonResponse['socialScore'];
                int g = jsonResponse['governanceScore'];
                int average = ((e+s+g)/3).floor();
                _chartData.add(GDPData('Environmental', e, Color(0x410F57)));
                _chartData.add(GDPData('Governmental', g, Color(0x027333)));
                _chartData.add(GDPData('Social', s, Color(0xF2CD32)));
                _chartData.add(GDPData('Average', average, Color(0xE74236)));
              });
            },
            child: Text('Get Data'),
          ),
          ElevatedButton(
            child: Text('Go back'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      )
    );
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.pointColor);
  final String continent;
  final int gdp;
  final Color pointColor;
}