
import 'package:highty_inventory/domain/entities/order.dart';
import 'package:highty_inventory/domain/entities/stock.dart';

abstract class StockRepository {
  Future<List<Map<String, String>>?> fetch(String category);
}

abstract class UpdateStockRepository{
  Future<UpdateStock?> updateStock(UpdateStock newStock, UpdateStock initialStock);
  Future<UpdateStock?> updateStockAfterOrder(OrderDetail stockDiff);
}





