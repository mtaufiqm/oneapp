// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:my_first/models/inventories/transactions.dart';
import 'package:my_first/models/inventories/transactions_item.dart';

class TransactionsWithItem {
  Transactions transactions;
  List<TransactionsItemDetails> items;
  TransactionsWithItem({
    required this.transactions,
    required this.items,
  });


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'transactions': transactions.toJson(),
      'items': items.map((x) => x.toJson()).toList(),
    };
  }

  factory TransactionsWithItem.fromJson(Map<String, dynamic> map) {
    return TransactionsWithItem(
      transactions: Transactions.fromJson(map['transactions'] as Map<String,dynamic>),
      items: List<TransactionsItemDetails>.from((map['items'] as List<dynamic>).map<TransactionsItemDetails>((x) => TransactionsItemDetails.fromJson(x as Map<String,dynamic>)))
    );
  }

  @override
  String toString() => 'TransactionsWithItem(transactions: $transactions, items: $items)';

  @override
  int get hashCode => transactions.hashCode ^ items.hashCode;
}
