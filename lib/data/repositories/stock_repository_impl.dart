import 'dart:developer';
import 'package:highty_inventory/domain/repositories/stock_repository.dart';
import 'package:highty_inventory/domain/entities/stock.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StockRepositoryImpl implements StockRepository {
  final SupabaseClient supabase;

  StockRepositoryImpl(this.supabase);

  @override
  Future<List<Map<String, String>>?> fetch(String category) async {
    try {
      final response = await supabase
          .from('stock')
          .select('SKU, images')
          .eq('category', category);
  
      // if (response.error != null) {
      //   log('Error fetching stock: ${response.error!.message}');
      //   return null;
      // }
      
      log('halo, masuk kok');
      final data = response as List<dynamic>;
      final stocks = data.map((item) {
        return {
          'SKU': item['SKU'] as String,
          'images': item['images'] as String,
        };
      }).toList();

      log(response.toString());
      

      return stocks;
    } catch (e) {
      log('Exception occurred while fetching stock: $e');
      return null;
    }
  }
}

class UpdateStockRepositoryImpl implements UpdateStockRepository{
  final SupabaseClient supabase;

  UpdateStockRepositoryImpl(this.supabase);

  @override
  Future<UpdateStock?> updateStock(UpdateStock updateStock) async {
    Map<String, int> sizeStockMap = Map.fromIterables(updateStock.size, updateStock.stock);
    try{
      final response = await supabase
          .from('stock')
          .update({'stock':sizeStockMap})
          .eq('nama', updateStock.nama)
          .select();
        

      log('Halo, masuk ke update stock imlement kok');
      log(response.toString());
      if(response.isNotEmpty){
        return UpdateStock(stock: [1], size: ["1"], nama: "bisa");
      }
      return null;
    } catch (e) {
      log('Exception occured while updating stock: $e');
      return null;
    }
  }
}

