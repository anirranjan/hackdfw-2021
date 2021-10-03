import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

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
              const SizedBox(width: 250)
            ]));
  }
}
