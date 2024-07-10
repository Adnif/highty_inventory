import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highty_inventory/domain/entities/order.dart';
import 'package:highty_inventory/domain/usecases/order.dart';

class OrderState {
  final bool isLoading;
  final String? errorMessage;
  final List<Order>? order;

  OrderState({this.isLoading = false, this.errorMessage, this.order});

  OrderState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Order>? order,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      order: order ?? this.order,
    );
  }
}

class OrderCubit extends Cubit<OrderState> {
  final FetchOrderUseCase fetchOrderUseCase;
  List<Order>? allOrders = [];

  OrderCubit(this.fetchOrderUseCase) : super(OrderState());

  Future<void> fetchOrder() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try{
      final order = await fetchOrderUseCase.fetch();
      if(isClosed) return;
      if(order != null){
        allOrders = order;
        emit(state.copyWith(isLoading: false, order: order));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: 'No orders found'));
      }
    } catch (e){
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: 'An error occured : $e'));
    }
  }

}

class OrderDetailState {
  final bool isLoading;
  final String? errorMessage;
  final OrderDetail? orderDetail;

  OrderDetailState({this.isLoading = false, this.errorMessage, this.orderDetail});

  OrderDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    OrderDetail? orderDetail,
  }) {
    return OrderDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      orderDetail: orderDetail ?? this.orderDetail,
    );
  }
}

class OrderDetailCubit extends Cubit<OrderDetailState>{
  final FetchOrderDetailUseCase fetchOrderDetailUseCase;
  OrderDetail? allOrderDetail;

  OrderDetailCubit(this.fetchOrderDetailUseCase) : super(OrderDetailState());

  Future<void> fetchOrderDetail(String orderId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try{
      final temp = await fetchOrderDetailUseCase.fetch(orderId);
      if(isClosed) return;
      if(temp != null){
        allOrderDetail = temp;
        emit(state.copyWith(isLoading: false, orderDetail: allOrderDetail));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: 'No details found'));
      }
    } catch (e){
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: 'An error occured : $e'));
    }
  }
}