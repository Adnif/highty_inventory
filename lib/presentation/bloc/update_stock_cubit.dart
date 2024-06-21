import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highty_inventory/domain/entities/stock.dart';
import 'package:highty_inventory/domain/repositories/stock_repository.dart';

class UpdateStockState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  UpdateStockState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  UpdateStockState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return UpdateStockState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class UpdateStockCubit extends Cubit<UpdateStockState> {
  final UpdateStockRepository updateStockRepository;

  UpdateStockCubit(this.updateStockRepository) : super(UpdateStockState());

  Future<void> updateStock(UpdateStock updateStock) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));
    try {
      final result = await updateStockRepository.updateStock(updateStock);
      if (result != null) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update stock', isSuccess: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'An error occurred: $e', isSuccess: false));
    }
  }
}
