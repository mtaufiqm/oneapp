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

//this class to get transactions item with products information
class TransactionsItemDetails {
  String? uuid;
  String transactions_uuid;
  String products_uuid;
  int quantity;

  //details_products
  String products_name;
  String products_image_link;
  String products_unit;
  TransactionsItemDetails({
    this.uuid,
    required this.transactions_uuid,
    required this.products_uuid,
    required this.quantity,
    required this.products_name,
    required this.products_image_link,
    required this.products_unit,
  });

  TransactionsItemDetails copyWith({
    String? uuid,
    String? transactions_uuid,
    String? products_uuid,
    int? quantity,
    String? products_name,
    String? products_image_link,
    String? products_unit,
  }) {
    return TransactionsItemDetails(
      uuid: uuid ?? this.uuid,
      transactions_uuid: transactions_uuid ?? this.transactions_uuid,
      products_uuid: products_uuid ?? this.products_uuid,
      quantity: quantity ?? this.quantity,
      products_name: products_name ?? this.products_name,
      products_image_link: products_image_link ?? this.products_image_link,
      products_unit: products_unit ?? this.products_unit,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'transactions_uuid': transactions_uuid,
      'products_uuid': products_uuid,
      'quantity': quantity,
      'products_name': products_name,
      'products_image_link': products_image_link,
      'products_unit': products_unit,
    };
  }

  factory TransactionsItemDetails.fromJson(Map<String, dynamic> map) {
    return TransactionsItemDetails(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      transactions_uuid: map['transactions_uuid'] as String,
      products_uuid: map['products_uuid'] as String,
      quantity: map['quantity'] as int,
      products_name: map['products_name'] as String,
      products_image_link: map['products_image_link'] as String,
      products_unit: map['products_unit'] as String,
    );
  }

  @override
  String toString() {
    return 'TransactionsItemDetails(uuid: $uuid, transactions_uuid: $transactions_uuid, products_uuid: $products_uuid, quantity: $quantity, products_name: $products_name, products_image_link: $products_image_link, products_unit: $products_unit)';
  }

  @override
  bool operator ==(covariant TransactionsItemDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.transactions_uuid == transactions_uuid &&
      other.products_uuid == products_uuid &&
      other.quantity == quantity &&
      other.products_name == products_name &&
      other.products_image_link == products_image_link &&
      other.products_unit == products_unit;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
      transactions_uuid.hashCode ^
      products_uuid.hashCode ^
      quantity.hashCode ^
      products_name.hashCode ^
      products_image_link.hashCode ^
      products_unit.hashCode;
  }
}
