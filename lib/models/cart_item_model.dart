class CartItem {
  final int? id;
  final int productId;
  final String name;
  final double price;
  int quantity;
  bool isSelected;
  final String imagePath;
  final String description;
  final String size;

  CartItem({
    this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.isSelected = true,
    this.imagePath = '',
    this.description = '',
    this.size = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imagePath': imagePath,
      'description': description,
      'size': size,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['product_id'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
      isSelected: true,
      imagePath: map['imagePath'] ?? 'assets/images/cake${map['product_id']}.jpg',
      description: map['description'] ?? '',
      size: map['size'] ?? 'Diameter 16 cm',
    );
  }
}