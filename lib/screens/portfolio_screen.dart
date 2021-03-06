import 'package:flutter/material.dart';
import 'package:hackdfw_app/colors.dart';
import 'package:hackdfw_app/models/esg_data.dart';
import 'package:hackdfw_app/providers/userinfo_provider.dart';
import 'package:hackdfw_app/stock_viewer.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hackdfw_app/supportstock.dart';
import 'dart:convert' as convert;

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<ESGData> _chartData = [
    ESGData('Governmental', 0, Color(0x027333)),
    ESGData('Social', 0, Color(0xF2CD32)),
    ESGData('Environmental', 0, Color(0x410F57)),
    ESGData('Total', 0, Color(0xE74236)),
  ];
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  var enableOverview = true;

  String predictionMessage = 'No Prediction';
  String newTicker = "";

  Future<Map<String, dynamic>> postRequest(
      String path, Map<String, dynamic> payload) async {
    var url = Uri.http("user:pass@localhost:5000", path);
    final response = await http.post(
      url,
      body: convert.jsonEncode(payload),
    );

    return convert.jsonDecode(response.body) as Map<String, dynamic>;
  }

  void updateWheel(tickers) async {
    final jsonResponse = await postRequest(
        "/portfolio_stats", <String, dynamic>{"tags": tickers});
    setState(() {
      _chartData = <ESGData>[];
      int e = jsonResponse['environmentalScore'].round();
      int s = jsonResponse['socialScore'].round();
      int g = jsonResponse['governanceScore'].round();
      int average = jsonResponse['prediction'].round();
      _chartData.add(ESGData('Governmental', g, EquiTreeColors.orangeish));
      _chartData.add(ESGData('Social', s, EquiTreeColors.purpleish));
      _chartData.add(ESGData('Environmental', e, EquiTreeColors.yellowish));
      _chartData.add(ESGData('Total', average, EquiTreeColors.greenish));
    });
  }

  @override
  Widget build(BuildContext context) {
    var userInfoProvider = Provider.of<UserInfoProvider>(context);

    return Scaffold(
        appBar:
            AppBar(title: Image.asset('assets/equitree-beige.png', height: 75)),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(children: <Widget>[
              const Spacer(),
              Row(
                children: [
                  const Text("Profile Overview", style: TextStyle(fontSize: 24),),
                  Switch(
                    value: enableOverview,
                    onChanged: (bool isOn) {
                      setState(() {
                        enableOverview = isOn;
                        print(isOn);
                        isOn = !isOn;
                      });
                    },
                    activeColor: EquiTreeColors.brownish,
                  ),
                ],
              ),
              Row(children: [
                Container(
                    width: 300,
                    child: DropdownSearch<String>.multiSelection(
                        mode: Mode.MENU,
                        showSelectedItems: true,
                        showSearchBox: true,
                        items: stocks,
                        label: "Portfolio stocks",
                        hint: "Add a stock...",
                        onChange: (List<String> selected) {
                          userInfoProvider.userPortfolio.tickers = selected;
                          updateWheel(selected);
                        },
                        selectedItems: []),
                ),
              ]),
              SizedBox(height: 20),
              Container(
                  width: 500,
                  height: 400,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: userInfoProvider.userPortfolio.tickers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TickerButton(
                            ticker:
                                userInfoProvider.userPortfolio.tickers[index]);
                      })),
              const Spacer()
            ]),
            enableOverview
                ? SizedBox(
                    width: 600,
                    height: 600,
                    child: SfCircularChart(
                        tooltipBehavior: _tooltipBehavior,
                        annotations: <CircularChartAnnotation>[
                          CircularChartAnnotation(
                            widget: Text("ESG: " + _chartData[3].score.toString(),
                                style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.normal)),
                            radius: '0%',
                          )
                        ],
                        series: <CircularSeries>[
                          RadialBarSeries<ESGData, String>(
                              dataSource: _chartData,
                              pointColorMapper: (ESGData data, _) =>
                                  data.pointColor,
                              xValueMapper: (ESGData data, _) => data.category,
                              yValueMapper: (ESGData data, _) => data.score,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              enableTooltip: true,
                              maximumValue: 100,
                              cornerStyle: CornerStyle.bothCurve)
                        ]))
                : StockViewer(
                    ticker: userInfoProvider.selectedTicker,
                  ),
          ],
        ));
  }
}

class TickerButton extends StatelessWidget {
  final String ticker;

  const TickerButton({Key? key, required this.ticker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userInfoProvider = Provider.of<UserInfoProvider>(context);

    return Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(60, 5, 60, 5),
        child: GestureDetector(
            onTap: () {
              userInfoProvider.updateTicker(ticker);
              print("test ${ticker}");
            },
            child: Card(
              child: ListTile(
                title: Text(ticker),
              ),
            )));
  }
}
