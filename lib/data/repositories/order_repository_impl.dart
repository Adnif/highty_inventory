import 'dart:developer';
import 'package:highty_inventory/data/api/tiktok.dart';
import 'package:highty_inventory/domain/entities/order.dart';
import 'package:highty_inventory/domain/repositories/order_repository.dart';
import 'dart:convert';


class OrderRepositoryImpl extends OrderRepository{

  @override
  Future<List<Order>?> fetchOrderList() async {
    return callOrderListTikTokApi();
  }
}

class OrderDetailRepositoryImpl extends OrderDetailRepository{

  @override
  Future<OrderDetail?> fetchOrderDetail(String orderId) {
    // TODO: implement fetchOrderDetail
    return callOrderDetailTiktokApi(orderId);
  }
}