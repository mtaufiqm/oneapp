
class CategoriesProducts {
  String product_uuid;
  String categories_uuid;
  
  CategoriesProducts({
    required this.product_uuid,
    required this.categories_uuid,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'product_uuid': product_uuid,
      'categories_uuid': categories_uuid,
    };
  }

  factory CategoriesProducts.fromJson(Map<String, dynamic> map) {
    return CategoriesProducts(
      product_uuid: map['product_uuid'] as String,
      categories_uuid: map['categories_uuid'] as String,
    );
  }

}
