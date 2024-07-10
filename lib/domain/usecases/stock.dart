import 'package:highty_inventory/domain/entities/stock.dart';
import 'package:highty_inventory/domain/repositories/stock_repository.dart';



class UpdateStockUseCase{
  final UpdateStockRepository repository;

  UpdateStockUseCase(this.repository);

  Future<void> updateStock(UpdateStock newStock, UpdateStock initialStock){
    return repository.updateStock(newStock, initialStock);
  }
}

