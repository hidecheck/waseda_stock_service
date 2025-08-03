import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
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

class StockListWidget extends StatefulWidget{
  const StockListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _StockListWidgetState();
}

class _StockListWidgetState extends State<StockListWidget>{
  // ① 状態を管理する変数（Future型）
  Future<Map<String, dynamic>>? _futureData;

  // ② HTTP通信を行う非同期メソッド
  Future<Map<String, dynamic>> fetchData() async {
    var baseUrl = "https://asia-northeast1-waseda-android.cloudfunctions.net/get-stock-price-v2";
    // クエリパラメータをMapで定義
    Map<String, String> params = {
      'code': '9697', // 値は文字列にする
    };
    var uri = Uri.parse(baseUrl).replace(queryParameters: params);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // 通信成功
      var data = jsonDecode(response.body);
      print(data);
      return data;

      // final Map<String, dynamic> data = json.decode(response.body);
      // // 'title'の値を返す
      // return data['title'];
    } else {
      // 通信失敗
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // ③ FutureBuilderを使って非同期処理の結果を待つ
        FutureBuilder<Map<String, dynamic>>(
          future: _futureData, // ここにFuture型の変数を渡す
          builder: (context, snapshot) {
            // 通信中の状態
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            // 通信にエラーがあった場合
            else if (snapshot.hasError) {
              return Text('エラー: ${snapshot.error}');
            }
            // 通信が成功してデータが取得できた場合
            else if (snapshot.hasData) {

              final List<dynamic> stocks = snapshot.data!['stocks'];
              if(stocks.isNotEmpty) {
                final Map<String, dynamic> firstStock = stocks[0];
                final String symbolName = firstStock["symbol_name"];
                final String price = firstStock["price"];

                return Column(
                  children: [
                    Text(
                      '銘柄名: $symbolName',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '現在価格: $price 円',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }else {
                return const Text('データが空です');
              }
            }
            // まだ通信が始まっていない初期状態
            else {
              return const Text('ボタンを押してデータを取得してください');
            }
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          // ④ ボタンが押されたときに状態変更メソッドを呼ぶ
          onPressed: (){
            setState(() {
              _futureData = fetchData();
            });
          },
          child: const Text('メッセージを変更'),
        ),
      ],
    );
  }
}

