import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cherish_cake.db');
    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS products');
        await db.execute('DROP TABLE IF EXISTS cart_items');
        await _onCreate(db, newVersion);
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        imagePath TEXT,
        description TEXT,
        size TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cart_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER,
        name TEXT,
        price REAL,
        quantity INTEGER,
        imagePath TEXT,
        description TEXT,
        size TEXT
      )
    ''');

    List<Product> initialProducts = [
      Product(
        name: 'Chocolate Truffle Delight',
        price: 150000,
        imagePath: 'assets/images/cake1.jpg',
        description: 'Kue lembut dilapisi krim coklat dan buah strawberry segar.',
        size: 'Diameter 18 cm (8-10 porsi)',
      ),
      Product(
        name: 'Strawberry Velvet Cake',
        price: 175000,
        imagePath: 'assets/images/cake2.jpg',
        description: 'Kue strawberry premium kaya rasa dengan lelehan slai strawberry pekat.',
        size: 'Diameter 20 cm (10-12 porsi)',
      ),
      Product(
        name: 'Pink Vanilla Blossom Cake',
        price: 160000,
        imagePath: 'assets/images/cake3.jpg',
        description: 'rasa vanilla dengan rasa manis yang lembut.',
        size: 'Diameter 16 cm (6-8 porsi)',
      ),
      Product(
        name: 'Vanilla Strawberry Bliss',
        price: 145000,
        imagePath: 'assets/images/cake4.jpg',
        description: 'Spons vanilla halus dengan isian kompot strawberry manis segar.',
        size: 'Diameter 16 cm (6-8 porsi)',
      ),
      Product(
        name: 'Strawberry Soft Cake',
        price: 165000,
        imagePath: 'assets/images/cake5.jpg',
        description: 'Cake dengan toping Strawberry yang segar dan manis',
        size: 'Diameter 18 cm (8-10 porsi)',
      ),
      Product(
        name: 'Caramel Macchiato Cake',
        price: 170000,
        imagePath: 'assets/images/cake6.jpg',
        description: 'Aroma kopi espresso pilihan dipadukan dengan saus karamel gurih.',
        size: 'Diameter 20 cm (10-12 porsi)',
      ),
    ];

    for (var product in initialProducts) {
      await db.insert('products', product.toMap());
    }
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart_items');
    return List.generate(maps.length, (i) => CartItem.fromMap(maps[i]));
  }

  Future<void> addToCart(Product product) async {
    final db = await database;
    final List<Map<String, dynamic>> existing = await db.query(
      'cart_items',
      where: 'product_id = ?',
      whereArgs: [product.id],
    );

    if (existing.isNotEmpty) {
      int currentQty = existing.first['quantity'];
      await db.update(
        'cart_items',
        {'quantity': currentQty + 1},
        where: 'product_id = ?',
        whereArgs: [product.id],
      );
    } else {
      await db.insert('cart_items', {
        'product_id': product.id,
        'name': product.name,
        'price': product.price,
        'quantity': 1,
        'imagePath': product.imagePath,
        'description': product.description,
        'size': product.size,
      });
    }
  }

  Future<void> updateCartItem(CartItem item) async {
    final db = await database;
    await db.update(
      'cart_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteCartItem(int id) async {
    final db = await database;
    await db.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}