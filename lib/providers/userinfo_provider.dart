import 'package:flutter/cupertino.dart';

class UserInfoProvider with ChangeNotifier {
  Porfolio userPortfolio = Porfolio("Test User", []);
  String selectedTicker = "";

  void updateTicker(newTicker) {
    selectedTicker = newTicker;
    notifyListeners();
  }
}

class Porfolio {
  final String user;
  List<String> tickers;
  Porfolio(this.user, this.tickers);
}
