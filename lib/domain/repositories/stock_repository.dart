
import 'package:highty_inventory/domain/entities/order.dart';
import 'package:highty_inventory/domain/entities/stock.dart';
import 'package:highty_inventory/domain/entities/test.dart';

abstract class StockRepository {
  Future<List<Product2?>?> fetchThumbnail(String category);
  Future<Product2?> fetchDetail(String sku);
}

abstract class UpdateStockRepository{
  Future<UpdateStock?> updateStock(UpdateStock newStock, UpdateStock initialStock);
  Future<UpdateStock?> updateStockAfterOrder(OrderDetail stockDiff);
}





