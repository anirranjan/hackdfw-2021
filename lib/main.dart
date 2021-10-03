import 'package:flutter/material.dart';
import 'package:hackdfw_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'HackDFW Submission',
        theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xffF8F7E3),
            appBarTheme: const AppBarTheme(color: Color(0xff382E31)),
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: const Color(0xff382E31),
                  displayColor: const Color(0xff382E31),
                )),
        home: const HomePage(),
        debugShowCheckedModeBanner: false);
  }
}
