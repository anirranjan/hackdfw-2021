import 'supportstock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_search/flutter_dropdown_search.dart';

class StockDropDown extends StatefulWidget {
  const StockDropDown({Key? key}) : super(key: key);

  @override
  State<StockDropDown> createState() => _StockDropDownState();
}

class _StockDropDownState extends State<StockDropDown> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESG Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
