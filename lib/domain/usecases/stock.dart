import 'package:highty_inventory/domain/entities/stock.dart';
import 'package:highty_inventory/domain/entities/test.dart';
import 'package:highty_inventory/domain/repositories/stock_repository.dart';

class UpdateStockUseCase{
  final UpdateStockRepository repository;

  UpdateStockUseCase(this.repository);

  Future<void> updateStock(UpdateStock newStock, UpdateStock initialStock){
    return repository.updateStock(newStock, initialStock);
  }
}

class FetchStockUseCase {
  final StockRepository repository;

  FetchStockUseCase(this.repository);

  Future<List<Product2?>?> fetchThumbnail(String category){
    return repository.fetchThumbnail(category);
  }

  Future<Product2?> fetchDetail(String sku){
    return repository.fetchDetail(sku);
  }
}

