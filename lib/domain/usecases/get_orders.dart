import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);

  Future<List<Order>> call() async {
    return await repository.getOrders();
  }
}
