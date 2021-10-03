import 'package:flutter/material.dart';
import 'package:hackdfw_app/models/gdp_data.dart';
import 'package:hackdfw_app/providers/userinfo_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  List<GDPData> _chartData = [
    GDPData('Governmental', 0, Color(0x027333)),
    GDPData('Social', 0, Color(0xF2CD32)),
    GDPData('Environmental', 0, Color(0x410F57)),
    GDPData('Total', 0, Color(0xE74236)),
  ];
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  Future<Map<String, dynamic>> postRequest(
      String path, Map<String, dynamic> payload) async {
    var url = Uri.http("user:pass@localhost:5000", path);
    // final response = await http.get(url);
    final response = await http.post(
      url,
      body: convert.jsonEncode(payload),
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
                        widget: Text("ESG: " + _chartData[3].gdp.toString(),
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
                    "/portfolio_stats", <String, dynamic>{
                  "tags": context.read<UserInfoProvider>().userPortfolio
                });
                setState(() {
                  _chartData = <GDPData>[];
                  int e = jsonResponse['environmentalScore'].round();
                  int s = jsonResponse['socialScore'].round();
                  int g = jsonResponse['governanceScore'].round();
                  int average = jsonResponse['prediction'].round();
                  _chartData.add(GDPData('Governmental', g, Color(0x027333)));
                  _chartData.add(GDPData('Social', s, Color(0xF2CD32)));
                  _chartData.add(GDPData('Environmental', e, Color(0x410F57)));
                  _chartData.add(GDPData('Total', average, Color(0xE74236)));
                });
              },
              child: const Text('Get Wheel Data'),
            ),
            /*
            TextField(
                onChanged: (text) {
                    print('First text field: $text');
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a search term',
                ),
            ),
            */
          ],
        ));
  }
}
