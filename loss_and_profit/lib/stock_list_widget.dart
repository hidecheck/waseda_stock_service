import 'package:flutter/material.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
              // リストデータを取得
              final List<dynamic> stocks = snapshot.data!;
              return Expanded(
                child: ListView.builder(
                  itemCount: stocks.length,
                  itemBuilder: (context, index) {
                    final stock = stocks[index];
                    return ListTile(
                      title: Text(stock['symbol_name']),
                      subtitle: Text('現在価格: ${stock['price']} 円'),
                    );
                  },
                ),
              );
            }
            // まだ通信が始まっていない初期状態
            else {
              return const Text('ボタンを押してデータを取得してください');
            }
          },
        ),
      ],
    );
  }
}

