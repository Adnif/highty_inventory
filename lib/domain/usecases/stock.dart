import 'package:highty_inventory/domain/entities/stock.dart';
import 'package:highty_inventory/domain/repositories/stock_repository.dart';


class FetchStockUseCase {
  final StockRepository repository;

  FetchStockUseCase(this.repository);

  Future<List<Map<String, String>>?> fetch(String category) {
    return repository.fetch(category);
  }
}

class FetchStockDetailUseCase {
  final StockDetailRepository repository;

  FetchStockDetailUseCase(this.repository);

  Future<StockDetail?> fetch(String sku) {
    return repository.fetch(sku);
  }
}

class UpdateStockUseCase{
  final UpdateStockRepository repository;

  UpdateStockUseCase(this.repository);

  Future<void> updateStock(UpdateStock updateStock){
    return repository.updateStock(updateStock);
  }
}

