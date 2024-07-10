import 'dart:convert';
import 'dart:developer';
import 'package:highty_inventory/domain/entities/order.dart';
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
  
      log('halo, masuk kok');
      final data = response as List<dynamic>;
      final stocks = data.map((item) {
        return {
          'SKU': item['SKU'] as String,
          'images': item['images'] as String,
        };
      }).toList();

      log('Stock : ${stocks}');

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
  Future<UpdateStock?> updateStock(UpdateStock newStock, UpdateStock oldStock) async {
    Map<String, int> sizeStockMap = Map.fromIterables(newStock.size, newStock.stock);

    List<int> newStockList = newStock.stock;
    List<int> oldStockList = oldStock.stock;

    List<int> difference = [];
    for (int i = 0; i < newStockList.length; i++) {
      // Calculate the difference for each pair of elements
      int diff = newStockList[i] - oldStockList[i];
      difference.add(diff);
    }

    log('Stock diff: ${difference.toString()}');

    Map<String, int> oldStockMap = Map.fromIterables(oldStock.size, difference);
    oldStockMap.removeWhere((key, value) => value == 0);

    try{
      log('Halo, masuk ke update stock imlement kok');
      final response = await supabase
          .from('stock')
          .update({'stock':sizeStockMap})
          .eq('nama', newStock.nama.toString())
          .select();
        
      final historyResponse = await supabase
        .from('history')
        .insert([
          {'nama': newStock.nama, 'atribut': oldStockMap},
        ])
        .select();

      if(response.isNotEmpty && historyResponse.isNotEmpty){
        return UpdateStock(stock: [1], size: ["1"], nama: "bisa");
      }
      return null;
    } catch (e) {
        log('Exception occured while updating stock: $e');
      return null;
    }
  }

  @override
  Future<UpdateStock?> updateStockAfterOrder(OrderDetail stockDiff) async {
    Map<String, Map<String, int>> groupedCount = {};

    // Extract size from SKU and count occurrences
    for (Product product in stockDiff.productList) {
      String prefix = extractPrefixFromSku(product.sku);
      String size = extractSizeFromSku(product.sku);
      
      if (!groupedCount.containsKey(prefix)) {
        groupedCount[prefix] = {};
      }

      if (groupedCount[prefix]!.containsKey(size)) {
        groupedCount[prefix]![size] = groupedCount[prefix]![size]! + 1;
      } else {
        groupedCount[prefix]![size] = 1;
      }
    }
    String jsonString = jsonEncode(groupedCount);


    try{
      final historyResponse = await supabase
        .from('history')
        .insert([{
          'order': stockDiff.orderId,
          'atribut':groupedCount
        }])
        .select();

      groupedCount.forEach((prefix, sizeMap) async {
        final updateResponse = await supabase
          .from('stock')
          .update({'stock': sizeMap})
          .eq('SKU', prefix)
          .select();
      });

    } catch(e){
      log('Exception occured while updating stock: $e');
    }
    //print(jsonString);
  }

  // Function to extract prefix from SKU
  String extractPrefixFromSku(String sku) {
    RegExp prefixPattern = RegExp(r'^[A-Z]+\d+');
    Match? match = prefixPattern.firstMatch(sku);
    if (match != null) {
      return match.group(0)!;
    }
    return 'Unknown';
  }

  // Function to extract size from SKU using regular expression
  String extractSizeFromSku(String sku) {
    RegExp sizePattern = RegExp(r'(XS|S|M|L|XL)$');
    Match? match = sizePattern.firstMatch(sku);
    if (match != null) {
      return match.group(1)!;
    }
    return 'Unknown';
  }
  
}

