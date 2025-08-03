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
  late double _minusOnePercentPrice;
  late double _plusZero5PercentPrice;
  late double _minusZero5PercentPrice;

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
    try {
      final double currentPrice = double.parse(_priceController.text);
      setState(() {
        _plusOnePercentPrice = currentPrice * 1.01;
        _minusOnePercentPrice = currentPrice * 0.99;
        _plusZero5PercentPrice = currentPrice * 1.005;
        _minusZero5PercentPrice = currentPrice * 0.995;
      });
    } catch (e) {
      setState(() {
        _plusOnePercentPrice = 0.0;
        _minusOnePercentPrice = 0.0;
        _plusZero5PercentPrice = 0.0;
        _minusZero5PercentPrice = 0.0;
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
                border: OutlineInputBorder()
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _incrementPrice,
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _decrementPrice,
          ),

          const SizedBox(width: 10),
          Text(
            '(+1%): ',
            style: const TextStyle(color: Colors.green),
          ),
          Text(
            _plusOnePercentPrice.toStringAsFixed(1),
            style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(width: 5),
          Text(
            '(-0.5%): ',
            style: const TextStyle(color: Colors.green),
          ),
          Text(
            _minusZero5PercentPrice.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '(-1%): ',
            style: const TextStyle(color: Colors.red),
          ),
          Text(
            _minusOnePercentPrice.toStringAsFixed(1),
            style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(width: 5),
          Text(
            '(+0.5%): ',
            style: const TextStyle(color: Colors.red),
          ),
          Text(
            _plusZero5PercentPrice.toStringAsFixed(1),
            style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold
            ),
          ),
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