import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:crypto/crypto.dart';
import 'package:highty_inventory/data/api/tiktok.dart';
import 'package:highty_inventory/domain/entities/order.dart';
import 'package:highty_inventory/domain/entities/test.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

const String secret =  "Zhfymr1AXEbbHXdZXhJLysXcgVzNwN1d";
const String url = 'https://api.lazada.co.id/rest';
String timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();
String yesterdayString = DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
// Set the time to 6:00 PM
DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
DateTime yesterdayAtSixPM = DateTime(yesterday.year, yesterday.month, yesterday.day, 18, 0, 0, 0, 0);
// Format the date to ISO 8601 string
String yesterdayFix = DateFormat("yyyy-MM-ddTHH:mm:ss").format(yesterdayAtSixPM).toString();


Map<String, String> objKeySort(Map<String, String> obj) {
  List<String> newKeys = obj.keys.toList()..sort();
  Map<String, String> newObj = {};
  for (String key in newKeys) {
    newObj[key] = obj[key]!;
  }
  return newObj;
}

String generateSignature(String secret, String path, Map<String, String> params, String body){
  Map<String, String> sortedParams = objKeySort(params);

  String signString = path;
  sortedParams.forEach((key, value) {
    signString += key + value;
  });

  var bytes = utf8.encode(signString);
  var key = utf8.encode(secret);

  var hmacSha256 = Hmac(sha256, key);
  var digest = hmacSha256.convert(bytes);

  return digest.toString();
}

Future<List<Order>?> callOrderLazadaApi() async {

  Map<String, String> params = {
    'app_key': '129591',
    'sign_method':'sha256',
    'access_token':'50000700306bX3racQ1cf90340QGShpBRXPRDDYnwclxcSQHAbBp4pWWG6aSsSJu',
    'timestamp': '${timestamp}000',
    'created_after': yesterdayFix,
    'limit':'10',
    'status':'ready_to_ship'
  };

  String body = json.encode({
    
  });

  String signature = generateSignature(secret, '/orders/get', params, body).toUpperCase();

  params['sign'] = signature;
  
  Uri uri = Uri.parse(url+'/orders/get').replace(queryParameters: params);

  try {
    http.Response response = await http.get(
      uri,
      //body: body,
    );

    Map<String, dynamic> temp = json.decode(response.body);

    if(response.statusCode == 200 && temp.containsKey('data')){
      
      List<dynamic> orderList = temp['data']['orders'];

      if(temp['data']['count'] != 0){
        List<Order> orders = orderList.map((order){
          return Order(orderId: order['order_id'].toString(), marketplace: 'assets/marketplace/lazada.png', status: 'Awaiting for shipment');
        }).toList();
        return orders;
      } else {
        return [];
      }

    } else {
      log('Lazada gagal pull');
      log('Request failed with status: ${response.statusCode}');
      log('Request failed with body: ${response.body}');
      return null;
    }
  } catch (e) {
    log('Lazada gagal pull');
    log('Request failed with error: $e');
    return null;
  }
}

Future<Order?> callOrderDetailLazadaApi(String orderId) async {
  Map<String, String> params = {
    'app_key': '129591',
    'sign_method':'sha256',
    'access_token':'50000700306bX3racQ1cf90340QGShpBRXPRDDYnwclxcSQHAbBp4pWWG6aSsSJu',
    'timestamp': '${timestamp}000',
    'order_id':orderId
  };

  String body = json.encode({
    
  });

  String signature = generateSignature(secret, '/order/items/get', params, body).toUpperCase();
  params['sign'] = signature;
  
  Uri uri = Uri.parse(url+'/order/items/get').replace(queryParameters: params);

  try {
    http.Response response = await http.get(
      uri,
      //body: body,
    );

    Map<String, dynamic> temp = json.decode(response.body);
    
    if(response.statusCode == 200 && temp.containsKey('data')){
      
      List<dynamic> productList = temp['data'];
      String resi = temp['data'][0]['tracking_code'];
      String date = temp['data'][0]['created_at'];
      String packageId = temp['data'][0]['package_id'];
      List<Product2> products = productList.map((product){
        return Product2(sku: product['sku'], imageLink: product['product_main_image']);
      }).toList();
      return Order(orderId: orderId, marketplace: 'lazada', status: 'anu', productList: products, resi: resi, date: date, packageId: packageId);

    } else {
      log('Lazada detail gagal pull');
      log('Request failed with status: ${response.statusCode}');
      log('Request failed with body: ${response.body}');
      return null;
    }
  } catch (e) {
    log('Lazada detail gagal pull');
    log('Request failed with error: $e');
    return null;
  }


}

Future<bool> confirmOrderLazadaApi(String packageId) async {
  Map<String, dynamic> body = {
    "packages":[{
      "package_id": packageId
    }]
  };

  String bodyParams = jsonEncode(body);

  Map<String, String> params = {
    'app_key': '129591',
    'sign_method':'sha256',
    'access_token':'50000700306bX3racQ1cf90340QGShpBRXPRDDYnwclxcSQHAbBp4pWWG6aSsSJu',
    'timestamp': '${timestamp}000',
    'dbsDeliveryReq':bodyParams
  };

  String signature = generateSignature(secret, '/order/package/sof/delivered', params, bodyParams).toUpperCase();
  params['sign'] = signature;
  
  Uri uri = Uri.parse(url+'/order/package/sof/delivered').replace(queryParameters: params);

  try {
    http.Response response = await http.post(
      uri,
      //body: body,
    );

    Map<String, dynamic> temp = json.decode(response.body);
    log(temp.toString());
    
    if(response.statusCode == 200 && temp.containsKey('result')){
      
      if(temp['result']['success'] == 'true'){
        return true;
      } else {
        return false;
      }

    } else {
      log('Lazada confirm gagal pull');
      log('Request failed with status: ${response.statusCode}');
      log('Request failed with body: ${response.body}');
      return false;
    }
  } catch (e) {
    log('Lazada confirm gagal pull');
    log('Request failed with error: $e');
    return false;
  }

}