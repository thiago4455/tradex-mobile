

class Product{
  final String name;
  final String ean;
  final double? price;
  final double minPrice;
  final double maxPrice;
  final String? image;

  Product({required this.name, required this.ean, required this.minPrice, required this.maxPrice, this.price, this.image}); 

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      ean: json['ean'],
      price: json['price'],
      image: json['image'],
      minPrice: double.parse(json['min_price']),
      maxPrice: double.parse(json['max_price'])
    );
  }

  static List<Product> fromRespose(List<dynamic> json){
    return json.map((e) => Product.fromJson(e)).toList();
  }
}

class Pricing{
  final int id;
  final double price;
  final DateTime createdAt;
  final String ean;


  Pricing({required this.id, required this.price, required this.createdAt, required this.ean});

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      id: json['id'],
      ean: json['product'],
      price: double.parse(json['price']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }


  static List<Pricing> fromRespose(List<dynamic> json){
    return json.map((e) => Pricing.fromJson(e)).toList();
  }
}