import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../utils/network_utils.dart';

class ProductRepository {
  static const String baseUrl = 'https://dummyjson.com/products';

  // Cache for products
  final Map<String, List<Product>> _cache = {};

  // Get products with pagination
  Future<List<Product>> getProducts({
    int limit = 10,
    int skip = 0,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'limit_${limit}_skip_${skip}';

    // Check cache first if not forcing refresh
    if (!forceRefresh && _cache.containsKey(cacheKey)) {
      print('Using cached products for $cacheKey');
      return _cache[cacheKey]!;
    }

    // Check internet connectivity
    final isConnected = await NetworkUtils.isInternetAvailable();
    if (!isConnected) {
      print('No internet connection, using cached data if available');
      return _cache[cacheKey] ?? [];
    }

    try {
      print('Fetching products from API: $baseUrl?limit=$limit&skip=$skip');
      final response = await http.get(
        Uri.parse('$baseUrl?limit=$limit&skip=$skip'),
      );

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'];

        print('Received ${productsJson.length} products from API');

        final products =
            productsJson.map((json) => Product.fromJson(json)).toList();

        // Cache the results
        _cache[cacheKey] = products;

        return products;
      } else {
        print('Error fetching products: ${response.statusCode}');
        print('Response body: ${response.body}');
        return _cache[cacheKey] ?? [];
      }
    } catch (e) {
      print('Error in getProducts: $e');
      return _cache[cacheKey] ?? [];
    }
  }

  // Get a single product by ID
  Future<Product?> getProductById(int id) async {
    try {
      print('Fetching product with ID: $id');
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        print('Error fetching product $id: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in getProductById: $e');
      return null;
    }
  }

  // Clear the cache
  void clearCache() {
    _cache.clear();
  }
}
