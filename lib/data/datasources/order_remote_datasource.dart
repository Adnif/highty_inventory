import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';

class OrderRemoteDataSource {
  final String apiUrl = "https://yourapi.com/orders";

  Future<List<OrderModel>> fetchOrders() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => OrderModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load orders");
    }
  }
}
