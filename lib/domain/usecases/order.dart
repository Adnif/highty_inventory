import 'package:highty_inventory/domain/entities/order.dart';
import 'package:highty_inventory/domain/repositories/order_repository.dart';

class FetchOrderUseCase {
  final OrderRepository repository;

  FetchOrderUseCase(this.repository);

  Future<List<Order>?> fetchOrderList() {
    return repository.fetchOrderList();
  }

  Future<Order?> fetchOrderDetail(String orderId) {
    return repository.fetchOrderDetail2(orderId);
  }
}

class FetchOrderDetailUseCase {
  final OrderRepository repository;

  FetchOrderDetailUseCase(this.repository);

  Future<Order?> fetch(String orderId) {
    return repository.fetchOrderDetail2(orderId);
  }
}

class ConfirmOrderUseCase {
  final OrderRepository repository;

  ConfirmOrderUseCase(this.repository);

  Future<bool> confirmOrder(String packageId) {
    return repository.confirmOrder(packageId);
  }
}