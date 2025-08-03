import 'package:flutter/material.dart';
import 'package:loss_and_profit/stock_list_item.dart';

import 'api_service.dart';

class StockListWidget extends StatefulWidget{
  const StockListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _StockListWidgetState();
}

class _StockListWidgetState extends State<StockListWidget>{
  // 状態を管理する変数（Future型）
  Future<List<dynamic>>? _futureData;

  // テキスト入力欄のコントローラー
  final TextEditingController _controller = TextEditingController();

  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    // ウィジェットが破棄されるときにコントローラーも破棄する
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: '銘柄コードを入力してください（"," 区切りで複数指定可）',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            // ④ ボタンが押されたときに状態変更メソッドを呼ぶ
            onPressed: (){
              setState(() {
                _futureData = _apiService.fetchData(_controller.text);
              });
            },
            child: const Text('メッセージを変更'),
          ),
          const SizedBox(height: 20),

          // FutureBuilderを使って非同期処理の結果を待つ
          FutureBuilder<List<dynamic>>(
            future: _futureData, // ここにFuture型の変数を渡す
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 通信中
                return const CircularProgressIndicator();
              }else if (snapshot.hasError) {
                // 通信エラー
                return Text('エラー: ${snapshot.error}');
              }else if (snapshot.hasData) {
                // 通信成功
                // リストデータを取得
                final List<dynamic> stocks = snapshot.data!;
                if (stocks.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: stocks.length,
                      itemBuilder: (context, index){
                        final stock = stocks[index];

                        return StockListItem(stock: stock);
                      },
                    ),
                  );
                }else {
                  // 通信成功でデータなし
                  return const Text('データが空です');
                }
              }else{
                // 通信前
                return const Text('ボタンを押してデータを取得してください');
              }
            },
          ),
        ],
      ),
    );
  }
}
