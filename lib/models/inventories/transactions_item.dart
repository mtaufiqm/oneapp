// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransactionsItem {
  String? uuid;
  String transactions_uuid;
  String products_uuid;
  int quantity;
  TransactionsItem({
    this.uuid,
    required this.transactions_uuid,
    required this.products_uuid,
    required this.quantity,
  });
  

  TransactionsItem copyWith({
    String? uuid,
    String? transactions_uuid,
    String? products_uuid,
    int? quantity,
  }) {
    return TransactionsItem(
      uuid: uuid ?? this.uuid,
      transactions_uuid: transactions_uuid ?? this.transactions_uuid,
      products_uuid: products_uuid ?? this.products_uuid,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'transactions_uuid': transactions_uuid,
      'products_uuid': products_uuid,
      'quantity': quantity,
    };
  }

  factory TransactionsItem.fromJson(Map<String, dynamic> map) {
    return TransactionsItem(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      transactions_uuid: map['transactions_uuid'] as String,
      products_uuid: map['products_uuid'] as String,
      quantity: map['quantity'] as int,
    );
  }


  @override
  String toString() {
    return 'TransactionsItem(uuid: $uuid, transactions_uuid: $transactions_uuid, products_uuid: $products_uuid, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant TransactionsItem other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.transactions_uuid == transactions_uuid &&
      other.products_uuid == products_uuid &&
      other.quantity == quantity;
  }

}
