import 'dart:convert';
import 'dart:developer';

import 'package:highty_inventory/domain/entities/stock.dart';
import 'package:highty_inventory/domain/repositories/stock_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StockDetailRepositoryImpl implements StockDetailRepository {
  final SupabaseClient supabase;

  StockDetailRepositoryImpl(this.supabase);

  @override
  Future<StockDetail?> fetch(String sku) async {
    try {
      final response = await supabase
          .from('stock')
          .select('stock, nama')
          .eq('SKU', sku);// Ensure execute() is called to get the response

      // if (response.error != null) {
      //   log('Error fetching stock detail: ${response.error!.message}');
      //   return null;
      // }

      log(response.toString());

      final data = response as List<dynamic>;
      if (data.isEmpty) {
        return null;
      }

      final item = data[0];

      log('item : ${item['nama']}');
      log('stock : ${item['stock'].runtimeType}');
      
      List<String> size = item['stock'].keys.toList();
      List<int> value = item['stock'].values.toList().cast<int>();

      final String nama = item['nama'].toString();

      return StockDetail(
        nama: nama,
        stock: value,
        size: size // Replace this with actual stock data if available
      );
    } catch (e) {
      log('Exception occurred while fetching stock detail: $e');
      return null;
    }
  }
}