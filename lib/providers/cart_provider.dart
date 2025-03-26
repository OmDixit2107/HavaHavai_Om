import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class CartState {
  final Map<int, int> items; // productId -> quantity
  final Map<int, Product> products; // productId -> Product

  CartState({
    required this.items,
    required this.products,
  });

  double get totalAmount {
    return items.entries.fold(0.0, (total, entry) {
      final product = products[entry.key];
      if (product == null) return total;
      return total + (product.price * entry.value);
    });
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(items: {}, products: {}));

  void addItem(Product product) {
    final currentItems = Map<int, int>.from(state.items);
    final currentProducts = Map<int, Product>.from(state.products);

    currentItems[product.id] = (currentItems[product.id] ?? 0) + 1;
    currentProducts[product.id] = product;

    state = CartState(
      items: currentItems,
      products: currentProducts,
    );
  }

  void removeItem(Product product) {
    final currentItems = Map<int, int>.from(state.items);
    final currentProducts = Map<int, Product>.from(state.products);

    if (currentItems.containsKey(product.id)) {
      if (currentItems[product.id]! > 1) {
        currentItems[product.id] = currentItems[product.id]! - 1;
      } else {
        currentItems.remove(product.id);
        currentProducts.remove(product.id);
      }

      state = CartState(
        items: currentItems,
        products: currentProducts,
      );
    }
  }

  void clearCart() {
    state = CartState(items: {}, products: {});
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.totalAmount;
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.items.values.fold(0, (total, quantity) => total + quantity);
});
