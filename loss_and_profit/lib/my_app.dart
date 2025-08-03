import 'package:flutter/material.dart';
import 'package:loss_and_profit/stock_list_widget.dart';

class MyApp extends StatelessWidget{

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Stock Price",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Loss and Profit'),
        ),
        body: const Center(
          child: StockListWidget(),
        ),
      ),
    );
  }
}
