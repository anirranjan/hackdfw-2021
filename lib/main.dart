import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'stock_viewer.dart';

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
  String environmentalMessage = '';
  String socialMessage = '';
  String governanceMessage = '';
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
          Padding(padding: const EdgeInsets.all(10.0)),
          Text(environmentalMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          Text(socialMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          Text(governanceMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          TextButton(
            onPressed: () async {
              var url = Uri.http("user:pass@localhost:5000", "");
              final response = await http.get(url);
              var jsonResponse =
                  convert.jsonDecode(response.body) as Map<String, dynamic>;
              setState(() {
                environmentalMessage = "Environmental: " +
                    jsonResponse['environmentalScore'].toString();
                socialMessage =
                    "Social: " + jsonResponse['socialScore'].toString();
                governanceMessage =
                    "Governance: " + jsonResponse['governanceScore'].toString();
              });
            },
            child: Text('Get Data'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => StockViewer()));
          },
          label: const Text('Go to Graph Page')),
    );
  }
}
