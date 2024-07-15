import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highty_inventory/domain/entities/order.dart';
import 'package:highty_inventory/domain/entities/test.dart';
import 'package:highty_inventory/domain/usecases/order.dart';

class OrderState {
  final bool isLoading;
  final String? errorMessage;
  final List<Order>? orderList;
  Order? orderDetail;
  

  OrderState({this.isLoading = false, this.errorMessage, this.orderList, this.orderDetail});

  OrderState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Order>? orderList,
    Order? orderDetail,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      orderList: orderList ?? this.orderList,
      orderDetail: orderDetail ?? this.orderDetail
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
      final order = await fetchOrderUseCase.fetchOrderList();
      if(isClosed) return;
      if(order != null){
        allOrders = order;
        emit(state.copyWith(isLoading: false, orderList: order));
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
  final Order? orderDetail;

  OrderDetailState({this.isLoading = false, this.errorMessage, this.orderDetail});

  OrderDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    Order? orderDetail,
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
  Order? allOrderDetail;

  OrderDetailCubit(this.fetchOrderDetailUseCase) : super(OrderDetailState());

  Future<void> fetchOrderDetail(String orderId) async {
    
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try{
      final temp = await fetchOrderDetailUseCase.fetch(orderId);
      if(isClosed) return;
      if(temp != null){
        allOrderDetail = temp;
        log(allOrderDetail.toString());
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

class ConfirmOrderState {
  final bool isLoading;
  final String? errorMessage;
  final bool? check;

  ConfirmOrderState({this.isLoading = false, this.errorMessage, this.check});

  ConfirmOrderState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? check,
  }) {
    return ConfirmOrderState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      check: check ?? this.check,
    );
  }
}

class ConfirmOrderCubit extends Cubit<ConfirmOrderState>{
  final ConfirmOrderUseCase confirmOrderUseCase;
  bool? check;

  ConfirmOrderCubit(this.confirmOrderUseCase) : super(ConfirmOrderState());

  Future<void> confirmOrder(String packageId) async {
    
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try{
      final temp = await confirmOrderUseCase.confirmOrder(packageId);
      if(isClosed) return;
      if(temp != null){
        check = temp;
        log(check.toString());
        emit(state.copyWith(isLoading: false, check: check));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: 'No status found'));
      }
    } catch (e){
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: 'An error occured : $e'));
    }
  }
}