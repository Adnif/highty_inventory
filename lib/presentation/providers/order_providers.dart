// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../domain/entities/order.dart';
// import '../../domain/usecases/get_orders.dart';
// import '../../data/repositories/order_repository_impl.dart';
// import '../../data/datasources/order_remote_datasource.dart';

// final orderRepositoryProvider = Provider<OrderRepositoryImpl>((ref) {
//   return OrderRepositoryImpl(OrderRemoteDataSource());
// });

// final getOrdersProvider = Provider<GetOrders>((ref) {
//   return GetOrders(ref.read(orderRepositoryProvider));
// });

// final ordersFutureProvider = FutureProvider<List<Order>>((ref) async {
//   final getOrders = ref.read(getOrdersProvider);
//   return await getOrders();
// });
