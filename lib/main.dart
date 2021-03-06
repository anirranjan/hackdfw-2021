import 'package:flutter/material.dart';
import 'package:hackdfw_app/colors.dart';
import 'package:hackdfw_app/providers/userinfo_provider.dart';
import 'package:hackdfw_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => UserInfoProvider())],
        child: MaterialApp(
            title: 'HackDFW Submission',
            theme: ThemeData(
                scaffoldBackgroundColor: const Color(0xffF8F7E3),
                appBarTheme: const AppBarTheme(color: EquiTreeColors.brownish),
                textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: const Color(0xff382E31),
                      displayColor: const Color(0xff382E31),
                    )),
            home: const HomePage(),
            debugShowCheckedModeBanner: false));
  }
}
