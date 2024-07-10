import 'package:highty_inventory/domain/entities/order.dart';
import 'package:highty_inventory/domain/repositories/order_repository.dart';

class FetchOrderUseCase {
  final OrderRepository repository;

  FetchOrderUseCase(this.repository);

  Future<List<Order>?> fetch() {
    return repository.fetchOrderList();
  }
}

class FetchOrderDetailUseCase {
  final OrderDetailRepository repository;

  FetchOrderDetailUseCase(this.repository);

  Future<OrderDetail?> fetch(String orderId) {
    return repository.fetchOrderDetail(orderId);
  }
}