import 'dart:developer';

import 'package:highty_inventory/domain/entities/test.dart';
import 'package:highty_inventory/domain/repositories/test_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StockRepository2Impl implements StockRepository2 {
  final SupabaseClient supabase;

  StockRepository2Impl(this.supabase);

  @override
  Future<List<Product2?>?> fetchThumbnail(String category) async {
    try{
      final response = await supabase
        .from('stock')
        .select('SKU, images')
        .eq('category', category);
      
      log('halo, masuk yang kedua kok');
      final data = response as List<dynamic>;
      final stocks = data.map((item) {
        return Product2(sku: item['SKU'], imageLink: item['images']);
      }).toList();

      return stocks;
    } catch(e){
      log('Exception occurred while fetching stock: $e');
      return null;
    }
  }

  @override
  Future<Product2?> fetchDetail(String sku) async {
    // TODO: implement fetchDetail
    try{
      final response = await supabase 
        .from('stock')
        .select('stock, nama, images')
        .eq('SKU', sku);
      
      final data = response as List<dynamic>;
      if(data.isEmpty){
        return null;
      }

      final item = data[0];

      return Product2(
        sku: sku, 
        name: item['nama'].toString(),
        imageLink: item['images'].toString(),
        stock: item['stock']
      );
    } catch(e){
      log('Exception occurred while fetching stock detail: $e');
      return null;
    }
  }
}
