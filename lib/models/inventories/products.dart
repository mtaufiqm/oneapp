// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Products {
  String? uuid;
  String name;
  String image_link;
  String unit;
  int stock_quantity;
  String created_at;
  String created_by;
  Products({
    this.uuid,
    required this.name,
    required this.image_link,
    required this.unit,
    required this.stock_quantity,
    required this.created_at,
    required this.created_by,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'name': name,
      'image_link': image_link,
      'unit': unit,
      'stock_quantity': stock_quantity,
      'created_at': created_at,
      'created_by': created_by,
    };
  }

  factory Products.fromMap(Map<String, dynamic> map) {
    return Products(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      name: map['name'] as String,
      image_link: map['image_link'] as String,
      unit: map['unit'] as String,
      stock_quantity: map['stock_quantity'] as int,
      created_at: map['created_at'] as String,
      created_by: map['created_by'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Products.fromJson(String source) => Products.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Products(uuid: $uuid, name: $name, image_link: $image_link, unit: $unit, stock_quantity: $stock_quantity, created_at: $created_at, created_by: $created_by)';
  }

}
