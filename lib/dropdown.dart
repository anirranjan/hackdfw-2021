import 'dart:html';
import 'supportstock.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dropdown_search/flutter_dropdown_search.dart';

class StockDropDown extends StatelessWidget {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ESG Search'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(children: [
          FlutterDropdownSearch(
            textController: _controller,
            items: stocks,
            dropdownHeight: 300,
          )
        ]),
      ),
    );
  }
}
