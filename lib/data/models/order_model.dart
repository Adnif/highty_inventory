import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel extends Order {
  OrderModel({
    required String receipt,
    required String orderId,
    required String status,
    required List<String> items,
    required String logoUrl,
  }) : super(
      receipt: receipt,
      orderId: orderId,
      status: status,
      items: items,
      logoUrl: logoUrl,
    );

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
