import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';
import '../providers/cart_provider.dart';

// Product repository provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// Cache for products
final Map<String, List<Product>> _productsCache = {};

// Base provider for products that handles fetching with parameters
final productsProvider = FutureProvider.family
    .autoDispose<List<Product>, Map<String, dynamic>>((ref, params) async {
  final repository = ref.read(productRepositoryProvider);

  // Create cache key from parameters
  final cacheKey = params.entries.map((e) => '${e.key}_${e.value}').join('_');

  // Keep provider alive
  ref.keepAlive();

  try {
    // Check cache first
    if (_productsCache.containsKey(cacheKey)) {
      print('Using cached products for $cacheKey');
      return _productsCache[cacheKey]!;
    }

    // Fetch products
    final products = await repository.getProducts(
      limit: params['limit'] as int? ?? 10,
      skip: params['skip'] as int? ?? 0,
    );

    // Cache products
    _productsCache[cacheKey] = products;

    return products;
  } catch (e) {
    print('Error fetching products: $e');
    // Return empty list or cached results on error
    return _productsCache[cacheKey] ?? [];
  }
});

// State for the catalogue screen
class CatalogueProductsNotifier extends StateNotifier<List<Product>> {
  final Ref ref;
  int _currentPage = 0;
  final int _productsPerPage = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  CatalogueProductsNotifier(this.ref) : super([]) {
    // Initial load is handled separately
  }

  // Initial load
  Future<void> loadInitialData() async {
    if (state.isNotEmpty) return; // Already loaded

    _isLoading = true;

    try {
      final params = {
        'limit': _productsPerPage,
        'skip': 0,
      };

      final productsFuture = await ref.read(productsProvider(params).future);
      state = productsFuture;
      _currentPage = 0;
      _hasMore = productsFuture.length == _productsPerPage;
    } catch (e) {
      print('Error loading initial products: $e');
    } finally {
      _isLoading = false;
    }
  }

  // Load more products
  Future<void> loadMoreProducts() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;

    try {
      final nextPage = _currentPage + 1;
      final params = {
        'limit': _productsPerPage,
        'skip': nextPage * _productsPerPage,
      };

      final newProducts = await ref.read(productsProvider(params).future);

      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        state = [...state, ...newProducts];
        _currentPage = nextPage;
        _hasMore = newProducts.length == _productsPerPage;
      }
    } catch (e) {
      print('Error loading more products: $e');
    } finally {
      _isLoading = false;
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    if (_isLoading) return;

    _isLoading = true;

    try {
      // Clear cache
      _productsCache.clear();

      final params = {
        'limit': _productsPerPage,
        'skip': 0,
      };

      final refreshedProducts = await ref.read(productsProvider(params).future);

      state = refreshedProducts;
      _currentPage = 0;
      _hasMore = refreshedProducts.length == _productsPerPage;
    } catch (e) {
      print('Error refreshing products: $e');
    } finally {
      _isLoading = false;
    }
  }
}

// Create StateNotifierProvider for catalogue products
final catalogueProductsProvider =
    StateNotifierProvider<CatalogueProductsNotifier, List<Product>>((ref) {
  return CatalogueProductsNotifier(ref);
});

final productDetailProvider = FutureProvider.family<Product, int>(
  (ref, productId) async {
    final repository = ref.watch(productRepositoryProvider);
    final product = await repository.getProductById(productId);
    if (product == null) {
      throw Exception('Product not found');
    }
    return product;
  },
);

// State for pagination
final currentPageProvider = StateProvider<int>((ref) => 0);
final productsPerPageProvider = Provider<int>((ref) => 10);

// For tracking loading state
final isLoadingMoreProvider = StateProvider<bool>((ref) => false);

final productProvider = FutureProvider.family<Product, int>((ref, id) async {
  final repository = ref.read(productRepositoryProvider);
  final product = await repository.getProductById(id);
  if (product == null) {
    throw Exception('Product not found');
  }
  return product;
});
