import 'package:flutter/material.dart';

void main() {
  runApp(const SnapPriceApp());
}

class SnapPriceApp extends StatelessWidget {
  const SnapPriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SnapPrice AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<ProductPrice> _products = <ProductPrice>[
    ProductPrice(
      id: '1',
      name: 'Leche Entera 1L',
      category: 'Lácteos',
      currentPrice: 1.2,
      previousPrice: 1.15,
      market: 'Mercado Centro',
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ProductPrice(
      id: '2',
      name: 'Arroz 1kg',
      category: 'Abarrotes',
      currentPrice: 1.85,
      previousPrice: 1.95,
      market: 'Super Norte',
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ProductPrice(
      id: '3',
      name: 'Tomate kg',
      category: 'Verduras',
      currentPrice: 1.4,
      previousPrice: 1.3,
      market: 'Mercado Centro',
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  String _selectedCategory = 'Todos';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _categories {
    final Set<String> categories = _products.map((ProductPrice p) => p.category).toSet();
    return <String>['Todos', ...categories];
  }

  List<ProductPrice> get _filteredProducts {
    return _products.where((ProductPrice product) {
      final bool categoryMatch = _selectedCategory == 'Todos' || product.category == _selectedCategory;
      final bool textMatch = product.name.toLowerCase().contains(_searchController.text.toLowerCase());
      return categoryMatch && textMatch;
    }).toList();
  }

  void _simulateScan() {
    setState(() {
      _products.add(
        ProductPrice(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Producto escaneado ${_products.length + 1}',
          category: 'Escaneados',
          currentPrice: 2.0 + (_products.length * 0.15),
          previousPrice: 1.8 + (_products.length * 0.1),
          market: 'Tienda Rápida',
          updatedAt: DateTime.now(),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Escaneo simulado completado y precio registrado.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<ProductPrice> visibleProducts = _filteredProducts;

    return Scaffold(
      appBar: AppBar(title: const Text('SnapPrice AI')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _simulateScan,
        icon: const Icon(Icons.camera_alt),
        label: const Text('Escanear'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Comparador inteligente de precios',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Base funcional del producto con búsqueda, filtros y registro de escaneos simulados.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar producto',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(_searchController.clear);
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((String category) {
                  final bool isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: visibleProducts.isEmpty
                  ? const Center(child: Text('No se encontraron productos.'))
                  : ListView.builder(
                      itemCount: visibleProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ProductPrice product = visibleProducts[index];
                        return ProductCard(product: product);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});

  final ProductPrice product;

  @override
  Widget build(BuildContext context) {
    final double difference = product.currentPrice - product.previousPrice;
    final bool priceUp = difference > 0;
    final Color trendColor = priceUp ? Colors.red : Colors.green;
    final IconData trendIcon = priceUp ? Icons.trending_up : Icons.trending_down;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('${product.market} • ${product.category}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '\$${product.currentPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(trendIcon, size: 14, color: trendColor),
                const SizedBox(width: 2),
                Text(
                  '${difference >= 0 ? '+' : ''}${difference.toStringAsFixed(2)}',
                  style: TextStyle(color: trendColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductPrice {
  ProductPrice({
    required this.id,
    required this.name,
    required this.category,
    required this.currentPrice,
    required this.previousPrice,
    required this.market,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String category;
  final double currentPrice;
  final double previousPrice;
  final String market;
  final DateTime updatedAt;
}
