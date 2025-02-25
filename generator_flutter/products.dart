
class Products {

String? uuid;
  String name;
  String image_link;
  String unit;
  int stock_quantity;
  String created_at;
  String created_by;
  String last_update;
  Products({
    this.uuid,
    required this.name,
    required this.image_link,
    required this.unit,
    required this.stock_quantity,
    required this.created_at,
    required this.created_by,
    required this.last_update,
  });

  Products copyWith({
    String? uuid,
    String? name,
    String? image_link,
    String? unit,
    int? stock_quantity,
    String? created_at,
    String? created_by,
    String? last_update,
  }) {
    return Products(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      image_link: image_link ?? this.image_link,
      unit: unit ?? this.unit,
      stock_quantity: stock_quantity ?? this.stock_quantity,
      created_at: created_at ?? this.created_at,
      created_by: created_by ?? this.created_by,
      last_update: last_update ?? this.last_update,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'name': name,
      'image_link': image_link,
      'unit': unit,
      'stock_quantity': stock_quantity,
      'created_at': created_at,
      'created_by': created_by,
      'last_update': last_update,
    };
  }

factory Products.fromJson(Map<String, dynamic> map) {
    return Products(
    uuid: map['uuid'] != null ? map['uuid'] as String : null,
    name: map['name'] as String,
    image_link: map['image_link'] as String,
    unit: map['unit'] as String,
    stock_quantity: map['stock_quantity'] as int,
    created_at: map['created_at'] as String,
    created_by: map['created_by'] as String,
    last_update: map['last_update'] as String,
    );
}

}
