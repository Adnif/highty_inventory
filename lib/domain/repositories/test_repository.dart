import 'package:highty_inventory/domain/entities/test.dart';

abstract class StockRepository2 {
  Future<List<Product2?>?> fetchThumbnail(String category);
  Future<Product2?> fetchDetail(String sku);
}
