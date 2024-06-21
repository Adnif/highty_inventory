import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highty_inventory/domain/entities/stock.dart';
import 'package:highty_inventory/domain/usecases/stock.dart';

class StockDetailState {
  final bool isLoading;
  final String? errorMessage;
  final StockDetail? stockDetail;

  StockDetailState({
    this.isLoading = false,
    this.errorMessage,
    this.stockDetail,
  });

  StockDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    StockDetail? stockDetail,
  }) {
    return StockDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      stockDetail: stockDetail ?? this.stockDetail,
    );
  }
}

class StockDetailCubit extends Cubit<StockDetailState> {
  final FetchStockDetailUseCase fetchStockDetailUseCase;

  StockDetailCubit(this.fetchStockDetailUseCase) : super(StockDetailState());

  Future<void> fetchStockDetail(String sku) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final stockDetail = await fetchStockDetailUseCase.fetch(sku);
      emit(state.copyWith(
        isLoading: false,
        stockDetail: stockDetail,
        errorMessage: stockDetail == null ? 'Stock detail not found' : null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'An error occurred: $e'));
    }
  }
}
