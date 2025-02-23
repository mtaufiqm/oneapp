// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StockTransactions {
  String? uuid;
  String product_uuid;
  int quantity;
  String status;    //PENDING / COMPLETED / CANCELED
  String created_at;
  String created_by;
  StockTransactions({
    this.uuid,
    required this.product_uuid,
    required this.quantity,
    required this.status,
    required this.created_at,
    required this.created_by,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'product_uuid': product_uuid,
      'quantity': quantity,
      'status': status,
      'created_at': created_at,
      'created_by': created_by,
    };
  }

  factory StockTransactions.fromMap(Map<String, dynamic> map) {
    return StockTransactions(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      product_uuid: map['product_uuid'] as String,
      quantity: map['quantity'] as int,
      status: map['status'] as String,
      created_at: map['created_at'] as String,
      created_by: map['created_by'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StockTransactions.fromJson(String source) => StockTransactions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StockTransactions(uuid: $uuid, product_uuid: $product_uuid, quantity: $quantity, status: $status, created_at: $created_at, created_by: $created_by)';
  }

}
