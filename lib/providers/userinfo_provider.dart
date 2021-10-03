import 'package:flutter/cupertino.dart';

class UserInfoProvider with ChangeNotifier {
  Porfolio userPortfolio = Porfolio("Test User", []);
}

class Porfolio {
  final String user;
  final List<String> tickers;
  Porfolio(this.user, this.tickers);
}
