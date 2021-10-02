import 'dart:html';

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
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  FirstScreen createState() => FirstScreen();
}

class FirstScreen extends State<HomePage> {
  String predictionMessage = 'No Prediction';
  // String environmentalMessage = '';
  // String socialMessage = '';
  // String governanceMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(padding: EdgeInsets.all(10.0)),
          Text(predictionMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          // Text(environmentalMessage,
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       fontSize: 24,
          //       fontWeight: FontWeight.bold,
          //     )),
          // Text(socialMessage,
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       fontSize: 24,
          //       fontWeight: FontWeight.bold,
          //     )),
          // Text(governanceMessage,
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       fontSize: 24,
          //       fontWeight: FontWeight.bold,
          //     )),
          TextButton(
            onPressed: () async {
              var url = Uri.http("user:pass@localhost:5000", "");
              // final response = await http.get(url);
              final response = await http.post(url, body: {
                'tag': "AAPL",
              });
              print(response.body);
              var jsonResponse =
                  convert.jsonDecode(response.body) as Map<String, dynamic>;
              setState(() {
                predictionMessage =
                    "Prediction: " + jsonResponse['prediction'].toString();
                // environmentalMessage = "Environmental: " +
                //     jsonResponse['environmentalScore'].toString();
                // socialMessage =
                //     "Social: " + jsonResponse['socialScore'].toString();
                // governanceMessage =
                //     "Governance: " + jsonResponse['governanceScore'].toString();
              });
            },
            child: Text('Get Data'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SecondScreen()));
          },
          label: const Text('Go to Graph Page')),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graph'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Go to Example Graph'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ThirdScreen()),
            );
          },
        ),
      ),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  List<GDPData> _chartData = [
    GDPData('Oceania', 1600, Color(0x410F57)),
    GDPData('Africa', 2490, Color(0xF8F7E3)),
    GDPData('S. America', 2900, Color(0x027333)),
    GDPData('Europe', 23050, Color(0x82BF45)),
    GDPData('N. America', 24880, Color(0xF2CD32)),
    GDPData('Asia', 34390, Color(0xE74236))
  ];

  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Center(
            child: Container(
                child: SfCircularChart(
                    title: ChartTitle(
                        text:
                            'Continent wise GDP - 2021 \n (in billions of USD)'),
                    legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap),
                    tooltipBehavior: _tooltipBehavior,
                    series: <CircularSeries>[
              RadialBarSeries<GDPData, String>(
                  dataSource: _chartData,
                  pointColorMapper: (GDPData data, _) => data.pointColor,
                  xValueMapper: (GDPData data, _) => data.continent,
                  yValueMapper: (GDPData data, _) => data.gdp,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                  maximumValue: 40000,
                  cornerStyle: CornerStyle.bothCurve)
            ]))));
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.pointColor);
  final String continent;
  final int gdp;
  final Color pointColor;
}
