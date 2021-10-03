import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:hackdfw_app/models/gdp_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockViewer extends StatefulWidget {
  const StockViewer(String ticker, {Key? key}) : super(key: key);

  @override
  _StockViewerState createState() => _StockViewerState();
}

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

class _StockViewerState extends State<StockViewer> {
  String company = 'No Data';
  String ticker = "AAPL";
  String companyType = 'No Data';

  List<GDPData> _chartData = [
    GDPData('Governmental', 0, Color(0x027333)),
    GDPData('Social', 0, Color(0xF2CD32)),
    GDPData('Environmental', 0, Color(0x410F57)),
    GDPData('Total', 0, Color(0xE74236)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        SizedBox(
            width: 400,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Input Ticker',
              ),
              onChanged: (text) {
                ticker = text;
              },
            )),
        Text("Name: " + company,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        Text("Industry: " + companyType,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        TextButton(
          onPressed: () async {
            if (ticker != "") {
              var url = Uri.http("user:pass@localhost:5000", "/company");
              final jsonResponse = await postRequest(
                  "/company", <String, String>{"tag": ticker});
              setState(() {
                company = jsonResponse['companyName'];
                ticker = jsonResponse['ticker'];
                companyType = jsonResponse['companyType'];

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
            }
          },
          child: const Text('Get Company Data'),
        ),
        SizedBox(
            height: 600,
            width: 600,
            child: SfCircularChart(
                tooltipBehavior: TooltipBehavior(enable: true),
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
                      pointColorMapper: (GDPData data, _) => data.pointColor,
                      xValueMapper: (GDPData data, _) => data.continent,
                      yValueMapper: (GDPData data, _) => data.gdp,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      enableTooltip: true,
                      maximumValue: 100,
                      cornerStyle: CornerStyle.bothCurve)
                ])),
      ],
    );
  }
}
