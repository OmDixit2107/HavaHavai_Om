import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/theme_toggle.dart';
import 'cart_screen.dart';

class CatalogueScreen extends ConsumerStatefulWidget {
  const CatalogueScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends ConsumerState<CatalogueScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial products when the screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(catalogueProductsProvider.notifier).loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the catalogue products
    final products = ref.watch(catalogueProductsProvider);
    final cartItemCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Catalogue',
          style: Theme.of(context).appBarTheme.titleTextStyle ??
              const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
        centerTitle: true,
        actions: [
          // Theme toggle button
          const ThemeToggle(),
          // Cart Icon with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).appBarTheme.iconTheme?.color,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartItemCount',
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
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(
              child: SingleChildScrollView(
                // Prevents overflow
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                    ),
                    SizedBox(height: 16),
                    Text('Loading products...'),
                  ],
                ),
              ),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  // Load more products when reaching the end
                  ref
                      .read(catalogueProductsProvider.notifier)
                      .loadMoreProducts();
                }
                return false;
              },
              child: RefreshIndicator(
                  onRefresh: () async {
                    // Refresh products
                    await ref
                        .read(catalogueProductsProvider.notifier)
                        .refreshProducts();
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.5, // Adjusted for our card dimensions
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(product: product);
                    },
                  )),
            ),
    );
  }
}
