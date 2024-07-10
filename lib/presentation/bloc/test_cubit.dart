import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highty_inventory/domain/entities/test.dart';
import 'package:highty_inventory/domain/usecases/test.dart';

class StockState2 {
  final bool isLoading;
  final String? errorMessage;
  final List<Product2?>? stockList;
  final Product2? product;

  StockState2({this.isLoading = false, this.errorMessage, this.stockList, this.product});

  StockState2 copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Product2?>? stockList,
    Product2? product
  }) {
    return StockState2(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      stockList: stockList ?? this.stockList,
      product: product ?? this.product
    );
  }
}

class StockCubit2 extends Cubit<StockState2> {
  final FetchStockUseCase2 fetchStockUseCase2;
  List<Product2?> allStocks = [];

  StockCubit2(this.fetchStockUseCase2) : super(StockState2());

  Future<void> fetchThumbnail(String category) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final stock = await fetchStockUseCase2.fetchThumbnail(category);
      if (stock != null) {
        allStocks = stock;
        emit(state.copyWith(isLoading: false, stockList: stock));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: 'No stocks found'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'An error occurred: $e'));
    }
  }

  Future<void> fetchDetail(String sku) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final product = await fetchStockUseCase2.fetchDetail(sku);
      log('ini product di cubit : $product');
      if (product != null) {
        emit(state.copyWith(isLoading: false, product: product));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: 'No stocks found'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'An error occurred: $e'));
    }
  }

  void filterStocks(String query) {
    final filteredStocks = allStocks.where((stock) {
      return stock!.sku!.toLowerCase().contains(query.toLowerCase());
    }).toList();
    emit(state.copyWith(stockList: filteredStocks));
  }

  
}