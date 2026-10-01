import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void _showCartItemDetail(BuildContext context, CartItem item) {
    final String imagePath = item.imagePath.isNotEmpty
        ? item.imagePath
        : 'assets/images/cake${item.productId}.jpg';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF2F9FC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2E5B70)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: const Color(0xFFD4EBF8),
                  child: const Icon(Icons.cake, size: 60, color: Color(0xFFF4B6C2)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rp ${item.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD9778F),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8BBECB).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.size.isNotEmpty ? item.size : 'Diameter 16 cm',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E5B70),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.description.isNotEmpty
                  ? item.description
                  : 'Kue lembut spesial buatan Cherish Cake dengan bahan-bahan pilihan berkualitas tinggi.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF4A6F82)),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4B6C2),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEBF6FA),
      appBar: AppBar(
        title: const Text(
          'Keranjang Saya',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF8BBECB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: cart.cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Color(0xFF8BBECB)),
                  SizedBox(height: 12),
                  Text(
                    'Keranjang belanjaanmu kosong',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6B96A6), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.cartItems.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final item = cart.cartItems[index];
                      final String imagePath = item.imagePath.isNotEmpty
                          ? item.imagePath
                          : 'assets/images/cake${item.productId}.jpg';

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD4EBF8), width: 1),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              activeColor: const Color(0xFFF4B6C2),
                              value: item.isSelected,
                              onChanged: (_) => cart.toggleSelection(item.id!),
                            ),
                            GestureDetector(
                              onTap: () => _showCartItemDetail(context, item),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  imagePath,
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 55,
                                      height: 55,
                                      color: const Color(0xFFEBF6FA),
                                      child: const Icon(Icons.cake, size: 30, color: Color(0xFFF4B6C2)),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF2E5B70),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.size.isNotEmpty ? item.size : 'Diameter 16 cm',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF6B96A6),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Rp ${item.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Color(0xFFD9778F),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.all(4),
                                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                                  color: const Color(0xFF8BBECB),
                                  onPressed: () => cart.updateQuantity(item.id!, -1),
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF2E5B70),
                                  ),
                                ),
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.all(4),
                                  icon: const Icon(Icons.add_circle_outline, size: 20),
                                  color: const Color(0xFFF4B6C2),
                                  onPressed: () => cart.updateQuantity(item.id!, 1),
                                ),
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.all(4),
                                  icon: const Icon(Icons.delete_outline, size: 18),
                                  color: const Color(0xFFE57373),
                                  onPressed: () => cart.removeItem(item.id!),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1AD4EBF8),
                        blurRadius: 10,
                        offset: Offset(0, -3),
                      )
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: const Color(0xFFF4B6C2),
                          value: cart.isAllSelected,
                          onChanged: cart.toggleSelectAll,
                        ),
                        const Text('Semua', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF2E5B70))),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Total Harga:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text(
                              'Rp ${cart.totalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD9778F),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4B6C2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 0,
                          ),
                          onPressed: cart.selectedCount == 0
                              ? null
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Checkout ${cart.selectedCount} item berhasil!'),
                                      backgroundColor: const Color(0xFFF4B6C2),
                                    ),
                                  );
                                },
                          child: Text(
                            'Checkout (${cart.selectedCount})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}