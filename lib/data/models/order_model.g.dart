// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      receipt: json['receipt'] as String,
      orderId: json['orderId'] as String,
      status: json['status'] as String,
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
      logoUrl: json['logoUrl'] as String,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'receipt': instance.receipt,
      'orderId': instance.orderId,
      'status': instance.status,
      'items': instance.items,
      'logoUrl': instance.logoUrl,
    };
