class Product {
  final int? id;
  final String name;
  final double price;
  final String imagePath;
  final String description;
  final String size; // Menambahkan informasi ukuran/diameter kue

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.size,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imagePath': imagePath,
      'description': description,
      'size': size,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      imagePath: map['imagePath'],
      description: map['description'],
      size: map['size'] ?? 'Diameter 16 cm',
    );
  }
}