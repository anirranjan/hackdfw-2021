import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'stock_viewer.dart';

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
        theme: new ThemeData(
            scaffoldBackgroundColor: const Color(0xffF8F7E3),
            appBarTheme: AppBarTheme(color: const Color(0xff382E31)),
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Color(0xff382E31),
                  displayColor: Color(0xff382E31),
                )),
        home: HomePage(),
        debugShowCheckedModeBanner: false);
  }
}

class HomePage extends StatefulWidget {
  @override
  FirstScreen createState() => FirstScreen();
}

class FirstScreen extends State<HomePage> {
  String predictionMessage = 'No Prediction';

  var random = new Random();

  List<GDPData> _chartData = [];

  @override
  void initState() {
    _chartData = [
      GDPData('Environmental', randInt(30, 100), Color(0x410F57)),
      GDPData('Governmental', randInt(30, 100), Color(0x027333)),
      GDPData('Social', randInt(30, 100), Color(0xF2CD32)),
      GDPData('Average', randInt(30, 100), Color(0xE74236))
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
                      MaterialPageRoute(builder: (_) => AboutScreen()));
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
          Container(
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
  @override
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  List<GDPData> _chartData = [
    GDPData('Environmental', 78, Color(0x410F57)),
    GDPData('Governmental', 50, Color(0x027333)),
    GDPData('Social', 62, Color(0xF2CD32)),
    GDPData('Average', 63, Color(0xE74236))
  ];
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  String predictionMessage = 'No Prediction';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Image.asset('assets/equitree-beige.png', height: 75)),
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
                            child: Text(_chartData[3].gdp.toString(),
                                style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.normal))),
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
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          enableTooltip: true,
                          maximumValue: 2500,
                          cornerStyle: CornerStyle.bothCurve)
                    ])),
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
                  int average = ((e + s + g) / 3).floor();
                  _chartData.add(GDPData('Environmental', e, Color(0x410F57)));
                  _chartData.add(GDPData('Governmental', g, Color(0x027333)));
                  _chartData.add(GDPData('Social', s, Color(0xF2CD32)));
                  _chartData.add(GDPData('Average', average, Color(0xE74236)));
                });
              },
              child: Text('Get Data'),
            ),
            Text(predictionMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            TextButton(
              onPressed: () async {
                var url = Uri.http("user:pass@localhost:5000", "");
                // final response = await http.get(url);
                final response = await http.post(
                  url,
                  body: jsonEncode(<String, String>{
                    "tag": "AAPL",
                  }),
                );
                var jsonResponse =
                    convert.jsonDecode(response.body) as Map<String, dynamic>;
                setState(() {
                  predictionMessage =
                      "Prediction: " + jsonResponse['prediction'].toString();
                });
              },
              child: Text('Get Data'),
            ),
          ],
        ));
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Image.asset('assets/equitree-beige.png', height: 75)),
        body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('What is an ESG Score?',
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold)),
                    SizedBox(height: 25),
                    Text(
                        'An ESG score is a numerical judgement of a company\'s policies and\n'
                        'actions regarding three criteria: Environmental, Social, and Corporate\n'
                        'Governance. The better their practices and impact in the present, the\n'
                        'higher the score. Each criteria is rated individually, and a total score\n'
                        'is calculated from those three. The score not only reflects the values\n'
                        'of the company, but also its adaptability for the future. For example,\n'
                        'scoring high on Environmental means your company wouldn\'t be\n'
                        'harmed by more stringent regulations being placed on them in the future.',
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.normal))
                  ]),
              SizedBox(width: 250)
            ]));
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.pointColor);
  final String continent;
  final int gdp;
  final Color pointColor;
}
