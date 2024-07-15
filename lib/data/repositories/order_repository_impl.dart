import 'dart:developer';
import 'package:highty_inventory/data/api/lazada.dart';
import 'package:highty_inventory/data/api/test.dart';
import 'package:highty_inventory/data/api/tiktok.dart';
import 'package:highty_inventory/domain/entities/order.dart';
import 'package:highty_inventory/domain/repositories/order_repository.dart';
import 'dart:convert';


class OrderRepositoryImpl extends OrderRepository{

  @override
  Future<List<Order>?> fetchOrderList() async {
    //List<Order>? tiktokOrders = await callOrderListTikTokApi();
    List<Order>? lazadaOrders = await callOrderLazadaApi();


    List<Order>? allOrders =  [];
    //allOrders.addAll(tiktokOrders);
    allOrders.addAll(lazadaOrders!);

    return allOrders;
  }

  @override
  Future<Order?> fetchOrderDetail2(String orderId) {
    // TODO: implement fetchOrderDetail2
    //return callOrderDetailTiktokApi2(orderId);
    return callOrderDetailLazadaApi(orderId);
  }

  @override
  Future<bool> confirmOrder(String packageId) {
    return confirmOrderLazadaApi(packageId);
  }
}

class OrderDetailRepositoryImpl extends OrderDetailRepository{

  @override
  Future<OrderDetail?> fetchOrderDetail(String orderId) {
    // TODO: implement fetchOrderDetail
    return callOrderDetailTiktokApi(orderId);
  }
}