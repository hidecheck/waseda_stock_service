import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StockListItem extends StatefulWidget {
  final Map<String, dynamic> stock;

  const StockListItem({
    super.key,
    required this.stock,
  });

  @override
  State<StockListItem> createState() => _StockListItemState();
}

class _StockListItemState extends State<StockListItem> {
  // 価格を管理するコントローラー
  late final TextEditingController _priceController;
  // 計算結果を保持する状態変数
  late double _plusOnePercentPrice;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.stock['price']);
    _calculatePlusOnePercentPrice();

    // 入力が変更されたときに計算し、画面を更新
    _priceController.addListener(() {
      _calculatePlusOnePercentPrice();
    });
  }

  void _calculatePlusOnePercentPrice() {
    print("_calculatePlusOnePercentPrice");
    try {
      final double currentPrice = double.parse(_priceController.text);
      setState(() {
        _plusOnePercentPrice = currentPrice * 1.01;
        print(_plusOnePercentPrice);
      });
    } catch (e) {
      print(e);
      setState(() {
        _plusOnePercentPrice = 0.0;
      });
    }
  }

  void _incrementPrice() {
    try {
      double currentPrice = double.parse(_priceController.text);
      currentPrice++;
      _priceController.text = currentPrice.toString();
    } catch (e) {
      // エラーの場合は何もしない
    }
  }

  void _decrementPrice() {
    try {
      double currentPrice = double.parse(_priceController.text);
      if (currentPrice > 0) {
        currentPrice--;
        _priceController.text = currentPrice.toString();
      }
    } catch (e) {
      // エラーの場合は何もしない
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.stock['symbol_name']),
      subtitle: Row(
        children: [
          SizedBox(
            width: 100,
            child: TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _decrementPrice,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _incrementPrice,
          ),

          const SizedBox(width: 10),
          Text(
            '(+1%): ${_plusOnePercentPrice.toStringAsFixed(1)} 円',
            style: const TextStyle(color: Colors.green),
          )
        ],
      ),

    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }
}