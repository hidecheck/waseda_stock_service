
import 'dart:convert';

import 'package:http/http.dart' as http;

const String BASE_URL = 'https://asia-northeast1-waseda-android.cloudfunctions.net';
const String ENDPOINT = '/get-stock-price-v2';


class ApiService{
  Future<List<dynamic>> fetchData(String stockCode) async {
    var baseUrl = BASE_URL + ENDPOINT;
    Map<String, String> params = {
      'code': stockCode,
    };
    var uri = Uri.parse(baseUrl).replace(queryParameters: params);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = jsonDecode(response.body);
      print(decodedData);
      return decodedData['stocks'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}