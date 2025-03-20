// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Transactions {
  String? uuid;
  String status;
  String created_at;
  String created_by;
  String last_updated;
  Transactions({
    this.uuid,
    required this.status,
    required this.created_at,
    required this.created_by,
    required this.last_updated,
  });
  

  Transactions copyWith({
    String? uuid,
    String? status,
    String? created_at,
    String? created_by,
    String? last_updated,
  }) {
    return Transactions(
      uuid: uuid ?? this.uuid,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      created_by: created_by ?? this.created_by,
      last_updated: last_updated ?? this.last_updated,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'status': status,
      'created_at': created_at,
      'created_by': created_by,
      'last_updated': last_updated,
    };
  }

  factory Transactions.fromJson(Map<String, dynamic> map) {
    return Transactions(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      status: map['status'] as String,
      created_at: map['created_at'] as String,
      created_by: map['created_by'] as String,
      last_updated: map['last_updated'] as String,
    );
  }


  @override
  String toString() {
    return 'Transactions(uuid: $uuid, status: $status, created_at: $created_at, created_by: $created_by, last_updated: $last_updated)';
  }

  @override
  bool operator ==(covariant Transactions other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.status == status &&
      other.created_at == created_at &&
      other.created_by == created_by &&
      other.last_updated == last_updated;
  }

}
