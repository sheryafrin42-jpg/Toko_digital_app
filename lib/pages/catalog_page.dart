import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/db_helper.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import 'cart_page.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late Future<List<Product>> _productsFuture;
  String _searchQuery = '';

  // Palette Warna: Baby Blue Mix Soft Pink
  static const Color babyBluePrimary = Color(0xFFA2C4C9);
  static const Color babyBlueDark = Color(0xFF4A6B74);
  static const Color softPinkAccent = Color(0xFFE8ADB2);
  static const Color softPinkLight = Color(0xFFFAF0F1);
  static const Color bgCanvas = Color(0xFFF2F7F8);

  @override
  void initState() {
    super.initState();
    _productsFuture = DBHelper().getProducts();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartProvider>().fetchCartItems();
      }
    });
  }

  // Bottom Sheet ala Shopee (Gambar Utuh + Detail + Tombol Keranjang)
  void _showShopeeStyleDetail(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            top: 12,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(bottomSheetContext).padding.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicator Garis Atas ala Shopee
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // 1. Gambar Produk (Utuh & Tidak Terpotong)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  color: bgCanvas,
                  child: Image.asset(
                    product.imagePath,
                    fit: BoxFit.contain, // Memastikan gambar tampil utuh proporsional
                    cacheWidth: 500,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.cake, size: 60, color: softPinkAccent),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Harga & Label Ukuran
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: softPinkAccent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (product.size.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: softPinkLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: softPinkAccent.withOpacity(0.4)),
                      ),
                      child: Text(
                        product.size,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: babyBlueDark,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // 3. Nama Produk
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: babyBlueDark,
                ),
              ),
              const SizedBox(height: 12),

              // 4. Deskripsi
              const Text(
                'Deskripsi Produk',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.description.isEmpty
                    ? 'Tersedia kue lezat buatan rumahan dengan bahan berkualitas tinggi.'
                    : product.description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // 5. Tombol + Keranjang di Bagian Bawah
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: softPinkAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    context.read<CartProvider>().addToCart(product);
                    Navigator.pop(bottomSheetContext); // Tutup BottomSheet
                    
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} berhasil ditambah ke keranjang!'),
                        duration: const Duration(milliseconds: 1000),
                        backgroundColor: softPinkAccent,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text(
                    '+ Keranjang',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        backgroundColor: babyBluePrimary,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.cake, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Cherish Cake',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          Selector<CartProvider, int>(
            selector: (context, cart) =>
                cart.cartItems.fold<int>(0, (sum, item) => sum + item.quantity),
            builder: (context, totalQuantity, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartPage()),
                      );
                    },
                  ),
                  if (totalQuantity > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: softPinkAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '$totalQuantity',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: babyBluePrimary,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari cake favoritmu...',
                hintStyle: TextStyle(fontSize: 13, color: babyBlueDark.withOpacity(0.6)),
                prefixIcon: const Icon(Icons.search, color: softPinkAccent),
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Grid View
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: softPinkAccent));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada kue tersedia.'));
                }

                final filteredProducts = snapshot.data!
                    .where((p) => p.name.toLowerCase().contains(_searchQuery))
                    .toList();

                if (filteredProducts.isEmpty) {
                  return const Center(child: Text('Kue tidak ditemukan.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: babyBluePrimary.withOpacity(0.3), width: 1.2),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _showShopeeStyleDetail(product),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    product.imagePath,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    cacheWidth: 300,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: softPinkLight,
                                        child: const Icon(Icons.cake, size: 50, color: softPinkAccent),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: babyBlueDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.size,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: softPinkAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: double.infinity,
                                height: 32,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: softPinkAccent,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<CartProvider>().addToCart(product);
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product.name} dimasukkan ke keranjang!'),
                                        duration: const Duration(milliseconds: 800),
                                        backgroundColor: softPinkAccent,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add_shopping_cart, size: 15),
                                  label: const Text(
                                    'Keranjang',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}