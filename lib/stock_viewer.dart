import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class StockViewer extends StatefulWidget {
  @override
  _StockViewerState createState() => _StockViewerState();
}

class _StockViewerState extends State<StockViewer> {
  String company = '';
  String ticker = '';
  String companyType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Viewer'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: const EdgeInsets.all(10.0)),
          Text(company,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          Text(ticker,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          Text(companyType,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          TextButton(
            onPressed: () async {
              var url = Uri.http("user:pass@localhost:5000", "/company");
              final response = await http.get(url);
              var jsonResponse =
                  convert.jsonDecode(response.body) as Map<String, dynamic>;
              setState(() {
                company = jsonResponse['companyName'];
                ticker = jsonResponse['ticker'];
                companyType = jsonResponse['companyType'];
              });
            },
            child: Text('Get Company Data'),
          ),
        ],
      ),
    );
  }
}
