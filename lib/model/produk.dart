class Produk {
  final int id;
  final String name;
  final int price;
  final String description;

  Produk({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      name: json['name'] ?? '',
      price: double.parse(json['price'].toString()).toInt(),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'price': price,
      'description': description,
    };
  }
}