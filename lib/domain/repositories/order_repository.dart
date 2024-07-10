import 'package:highty_inventory/domain/entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>?> fetchOrderList();
}

abstract class OrderDetailRepository{
  Future<OrderDetail?> fetchOrderDetail(String orderId);
}