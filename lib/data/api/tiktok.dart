import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'package:highty_inventory/domain/entities/order.dart';
import 'package:highty_inventory/presentation/constants/icons.dart';
import 'package:http/http.dart' as http;

const String secret = 'a66118f40c784c29525d7b342d22aae139920c6d';

String formatUnixTimestamp(String unixTimestampStr) {
  // Convert the string to an integer
  int unixTimestamp = int.parse(unixTimestampStr);
  
  // Create a DateTime object from the Unix timestamp
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
  
  // Define the desired date and time format
  DateFormat formatter = DateFormat('dd-MM-yy HH:mm');
  
  // Format the DateTime object
  return formatter.format(dateTime);
}

Map<String, String> objKeySort(Map<String, String> obj) {
  List<String> newKeys = obj.keys.toList()..sort();
  Map<String, String> newObj = {};
  for (String key in newKeys) {
    newObj[key] = obj[key]!;
  }
  return newObj;
}

String generateSignature(String secret, String path, Map<String, String> params, String body) {
  params.remove('sign');
  params.remove('access_token');
  Map<String, String> sortedParams = objKeySort(params);

  String signString = secret + path;
  sortedParams.forEach((key, value) {
    signString += key + value;
  });
  signString += body + secret;

  var bytes = utf8.encode(signString);
  var key = utf8.encode(secret);

  var hmacSha256 = Hmac(sha256, key);
  var digest = hmacSha256.convert(bytes);

  return digest.toString();
}

Future<List<Order>> callOrderListTikTokApi() async {
  String url = 'https://open-api.tiktokglobalshop.com/api/orders/search';
  String timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();

  Map<String, String> params = {
    'access_token': 'ROW_mGs8JwAAAAAZfs5w7f6GIx6cBy_-9vH3H3CHKlpE0r6WSlg_dnin4dUyFnSLw-E8-ZkWiFmi7OT01n5UM2gEevwdWcI0nf7aUTEKO1ls44bCnmUAF1GcEBVeHplGKqkzLKD5T6Z3ii-KgyNWlNH09M70W7HfncxsYoNHXE4nubvdqf5iq3B5lA',
    'app_key': '6cuijn10qomu0',
    'shop_cipher': '',
    'shop_id': '7495820846510082392',
    'timestamp': 'timestamp',
    'version': '202212'
  };

  String body = json.encode({
    'page_size': 10,
    'order_status': 112,
  });
   // Your request body here
  String signature = generateSignature(secret, '/api/orders/search', params, body);

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
      List<dynamic> orderList = temp['data']['order_list'];
      
      if(temp['data']['total'] != 0){
        List<Order> orders = orderList.map((order) {
          String status = '';
          if(order['order_status'] == 111){
            status = 'Awating for Shipment';
          }
          return Order(marketplace: 'assets/marketplace/tiktokshop.png', orderId: order['order_id'], status: status);
        }).toList();
        return orders;
      } else {
        return [];
      }
    } else {
      log('Order List Tiktok Gagal');
      log('Request failed with status: ${response.statusCode}');
      log('Request failed with body: ${response.body}');
      return [];
    }
  } catch (e) {
    log('Order List Tiktok Gagal');
    log('Request failed with error: $e');
    return [];
  }
}

Future<OrderDetail> callOrderDetailTiktokApi(String orderId) async {
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

      List<Product> productList = order.map((temp){
        return Product(nama: temp['product_name'], sku: temp['seller_sku'], imageLink: temp['sku_image']);
      }).toList();


      return OrderDetail(orderId: orderId, date: date, productList: productList);
    } else {
      log('Order Detail TikTok Gagal');
      log('Request failed with status: ${response.statusCode}');
      log('Request failed with body: ${response.body}');
      return OrderDetail(orderId: 'failed', date: 'XX-XXX-XXX', productList: []);
    }
  } catch (e) {
    log('Request failed with error: $e');
    return OrderDetail(orderId: 'failed', date: 'XX-XXX-XXX', productList: []);
  }
}