import 'package:highty_inventory/domain/entities/test.dart';

class Order {
  final String orderId;
  final String marketplace;
  List<Product2>? productList;
  final String status; 
  String? namaStaff;
  String? timestamp;
  String? resi;
  String? date;
  String? packageId;

  Order({required this.orderId, required this.marketplace, this.productList, required this.status, this.namaStaff, this.timestamp, this.resi, this.date, this.packageId});
}

class OrderDetail {
  final String orderId;
  final String date;
  final List<Product> productList;

  OrderDetail({required this.orderId, required this.date, required this.productList});
}

class Product{
  final String nama;
  final String sku;
  final String imageLink;

  Product({required this.nama, required this.sku, required this.imageLink});
}


