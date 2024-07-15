import 'package:highty_inventory/domain/entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>?> fetchOrderList();
  Future<Order?> fetchOrderDetail2(String orderId);
  Future<bool> confirmOrder(String packageId);
}

abstract class OrderDetailRepository{
  Future<OrderDetail?> fetchOrderDetail(String orderId);
}