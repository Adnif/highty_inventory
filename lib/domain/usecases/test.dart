import 'package:highty_inventory/domain/entities/test.dart';
import 'package:highty_inventory/domain/repositories/test_repository.dart';

class FetchStockUseCase2 {
  final StockRepository2 repository2;

  FetchStockUseCase2(this.repository2);

  Future<List<Product2?>?> fetchThumbnail(String category){
    return repository2.fetchThumbnail(category);
  }

  Future<Product2?> fetchDetail(String sku){
    return repository2.fetchDetail(sku);
  }
}