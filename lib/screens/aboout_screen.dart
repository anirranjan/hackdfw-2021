import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  final _esgBody =
      "An ESG score is a numerical judgement of a company's policies and actions regarding three criteria: Environmental, Social, and Corporate Governance. "
      "The better their practices and impact in the present, the higher the score. "
      "Each criteria is rated individually, and a total score is calculated from those three. "
      "The score not only reflects the values of the company, but also its adaptability for the future. "
      "For example, scoring high on Environmental means your company wouldn't be harmed by more stringent regulations being placed on them in the future. ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Image.asset('assets/equitree-beige.png', height: 75)),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(children: [
                  const Text('What is an ESG Score?',
                      style:
                          TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  Text(_esgBody,
                      style: TextStyle(
                          fontSize: 36, fontWeight: FontWeight.normal))
                ]),
              ),
            ),
          ],
        ));
  }
}
