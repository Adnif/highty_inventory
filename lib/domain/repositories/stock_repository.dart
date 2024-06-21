
import 'package:highty_inventory/domain/entities/stock.dart';

abstract class StockDetailRepository {
  Future<StockDetail?> fetch(String sku);
}

abstract class StockRepository {
  Future<List<Map<String, String>>?> fetch(String category);
}

abstract class UpdateStockRepository{
  Future<UpdateStock?> updateStock(UpdateStock updateStock);
}





