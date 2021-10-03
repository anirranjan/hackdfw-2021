import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'stock_viewer.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'screens/aboout_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'HackDFW Submission',
        theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xffF8F7E3),
            appBarTheme: const AppBarTheme(color: Color(0xff382E31)),
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: const Color(0xff382E31),
                  displayColor: const Color(0xff382E31),
                )),
        home: const HomePage(),
        debugShowCheckedModeBanner: false);
  }
}

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

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  List<GDPData> _chartData = [
    GDPData('Environmental', 78, Color(0x410F57)),
    GDPData('Governmental', 50, Color(0x027333)),
    GDPData('Social', 62, Color(0xF2CD32)),
    GDPData('Total', 63, Color(0xE74236))
  ];
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  String predictionMessage = 'No Prediction';
  String ticker = "AAPL";

  Future<Map<String, dynamic>> postRequest(
      String uri, Map<String, dynamic> payload) async {
    var url = Uri.http(uri, "");
    // final response = await http.get(url);
    final response = await http.post(
      url,
      body: jsonEncode(payload),
    );

    return convert.jsonDecode(response.body) as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Image.asset('assets/equitree-beige.png', height: 75)),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 600,
                width: 600,
                child: SfCircularChart(
                    tooltipBehavior: _tooltipBehavior,
                    annotations: <CircularChartAnnotation>[
                      CircularChartAnnotation(
                        widget: Text(_chartData[3].gdp.toString(),
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.normal)),
                        radius: '0%',
                      )
                    ],
                    series: <CircularSeries>[
                      RadialBarSeries<GDPData, String>(
                          dataSource: _chartData,
                          pointColorMapper: (GDPData data, _) =>
                              data.pointColor,
                          xValueMapper: (GDPData data, _) => data.continent,
                          yValueMapper: (GDPData data, _) => data.gdp,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                          enableTooltip: true,
                          maximumValue: 100,
                          cornerStyle: CornerStyle.bothCurve)
                    ])),
            TextButton(
              onPressed: () async {
                final jsonResponse = await postRequest(
                    "user:pass@localhost:5000",
                    <String, String>{"tag": ticker});
                setState(() {
                  _chartData = <GDPData>[];
                  int e = jsonResponse['environmentalScore'];
                  int s = jsonResponse['socialScore'];
                  int g = jsonResponse['governanceScore'];
                  int average = jsonResponse['prediction'].round();
                  _chartData.add(GDPData('Environmental', e, Color(0x410F57)));
                  _chartData.add(GDPData('Governmental', g, Color(0x027333)));
                  _chartData.add(GDPData('Social', s, Color(0xF2CD32)));
                  _chartData.add(GDPData('Total', average, Color(0xE74236)));
                });
              },
              child: const Text('Get Wheel Data'),
            ),
          ],
        ));
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.pointColor);
  final String continent;
  final int gdp;
  final Color pointColor;
}
