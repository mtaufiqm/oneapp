
class Carts {
  String? uuid;
  String product_uuid;
  int quantity;
  String created_at;
  String created_by;
  Carts({
    this.uuid,
    required this.product_uuid,
    required this.quantity,
    required this.created_at,
    required this.created_by,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'product_uuid': product_uuid,
      'quantity': quantity,
      'created_at': created_at,
      'created_by': created_by,
    };
  }

  factory Carts.fromJson(Map<String, dynamic> map) {
    return Carts(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      product_uuid: map['product_uuid'] as String,
      quantity: map['quantity'] as int,
      created_at: map['created_at'] as String,
      created_by: map['created_by'] as String,
    );
  }

  @override
  String toString() {
    return 'Carts(uuid: $uuid, product_uuid: $product_uuid, quantity: $quantity, created_at: $created_at, created_by: $created_by)';
  }

}
