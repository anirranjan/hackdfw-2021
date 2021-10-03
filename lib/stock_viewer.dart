import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:hackdfw_app/models/esg_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockViewer extends StatefulWidget {
  StockViewer({Key? key, required this.ticker}) : super(key: key);
  String ticker;

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
  String ticker = "No Data";
  String companyType = 'No Data';

  List<ESGData> _chartData = [
    ESGData('Governmental', 0, Color(0x027333)),
    ESGData('Social', 0, Color(0xF2CD32)),
    ESGData('Environmental', 0, Color(0x410F57)),
    ESGData('Total', 0, Color(0xE74236)),
  ];

  updateChart() async {
    if (ticker != "") {
      var url = Uri.http("user:pass@localhost:5000", "/company");
      final jsonResponse =
          await postRequest("/company", <String, String>{"tag": ticker});
      setState(() {
        company = jsonResponse['companyName'];
        ticker = jsonResponse['ticker'];
        companyType = jsonResponse['companyType'];

        _chartData = <ESGData>[];
        int e = jsonResponse['environmentalScore'].round();
        int s = jsonResponse['socialScore'].round();
        int g = jsonResponse['governanceScore'].round();
        int average = jsonResponse['prediction'].round();
        _chartData.add(ESGData('Governmental', g, Color(0x027333)));
        _chartData.add(ESGData('Social', s, Color(0xF2CD32)));
        _chartData.add(ESGData('Environmental', e, Color(0x410F57)));
        _chartData.add(ESGData('Total', average, Color(0xE74236)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ticker = widget.ticker;
    updateChart();

    return Column(
      children: [
        Spacer(),
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
        SizedBox(
            height: 600,
            width: 600,
            child: SfCircularChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                annotations: <CircularChartAnnotation>[
                  CircularChartAnnotation(
                    widget: Text("Predicted\nESG: " + _chartData[3].score.toString(),
                        style: const TextStyle(
                            fontSize: 36, fontWeight: FontWeight.normal)),
                    radius: '0%',
                  )
                ],
                series: <CircularSeries>[
                  RadialBarSeries<ESGData, String>(
                      dataSource: _chartData,
                      pointColorMapper: (ESGData data, _) => data.pointColor,
                      xValueMapper: (ESGData data, _) => data.category,
                      yValueMapper: (ESGData data, _) => data.score,
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
