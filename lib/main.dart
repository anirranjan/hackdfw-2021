import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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
  String testMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          Text(testMessage,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () async {
              var url = Uri.http("user:pass@localhost:5000", "");
              final response = await http.get(url);
              var jsonResponse =
                  convert.jsonDecode(response.body) as Map<String, dynamic>;
              setState(() {
                testMessage = jsonResponse['greetings'];
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
          child: Text('Go to Home'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
