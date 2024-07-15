import 'dart:convert';
import 'dart:developer';

import 'package:highty_inventory/data/api/tiktok.dart';
import 'package:highty_inventory/domain/entities/order.dart';
import 'package:highty_inventory/domain/entities/test.dart';
import 'package:http/http.dart' as http;

Future<Order?> callOrderDetailTiktokApi2(String orderId) async {
  String url = 'https://open-api.tiktokglobalshop.com/api/orders/detail/query';
  String timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();

  Map<String, String> params = {
    'access_token': 'ROW_mGs8JwAAAAAZfs5w7f6GIx6cBy_-9vH3H3CHKlpE0r6WSlg_dnin4dUyFnSLw-E8-ZkWiFmi7OT01n5UM2gEevwdWcI0nf7aUTEKO1ls44bCnmUAF1GcEBVeHplGKqkzLKD5T6Z3ii-KgyNWlNH09M70W7HfncxsYoNHXE4nubvdqf5iq3B5lA',
    'app_key': '6cuijn10qomu0',
    'shop_cipher': '',
    'shop_id': '7495820846510082392',
    'timestamp': timestamp,
    'version': '202212'
  };

  String body = json.encode({'order_id_list': [orderId]}); // Your request body here
  String signature = generateSignature(secret, '/api/orders/detail/query', params, body);
  
  params['sign'] = signature;
  params['access_token'] = 'ROW_mGs8JwAAAAAZfs5w7f6GIx6cBy_-9vH3H3CHKlpE0r6WSlg_dnin4dUyFnSLw-E8-ZkWiFmi7OT01n5UM2gEevwdWcI0nf7aUTEKO1ls44bCnmUAF1GcEBVeHplGKqkzLKD5T6Z3ii-KgyNWlNH09M70W7HfncxsYoNHXE4nubvdqf5iq3B5lA';
  
  Uri uri = Uri.parse(url).replace(queryParameters: params);

  try {
    http.Response response = await http.post(
      uri,
      headers: {
        'Content-Type' : 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> temp = json.decode(response.body);
      List<dynamic> order = temp['data']['order_list'][0]['order_line_list'];
      log(order.toString());
      String date = temp['data']['order_list'][0]['create_time'];
      
      // if(temp['data']['total'] != 0){
      //   List<OrderDetail> orders = orderList.map((order) {
      //     String status = '';
      //     if(order['order_status'] == 111){
      //       status = 'Awating for Shipment';
      //     }
      //     return OrderDetail(orderId: orderId, date: date, productList: productList);
      //   }).toList();
      //   return orders;
      // } else {
      //   return [];
      // }

      List<Product2> productList = order.map((temp){
        //return Product(nama: temp['product_name'], sku: temp['seller_sku'], imageLink: temp['sku_image']);
        return Product2(sku: temp['seller_sku'], imageLink: temp['sku_image']);
      }).toList();


      //return OrderDetail(orderId: orderId, date: date, productList: productList);
      return Order(orderId: orderId, marketplace: 'tiktok', productList: productList, status: 'Awaiting Shipment');
    } else {
      log('masuk bre');
      log('Request failed with status: ${response.statusCode}');
      log('Request failed with body: ${response.body}');
      return null;
    }
  } catch (e) {
    log('Request failed with error: $e');
    return null;
  }
}