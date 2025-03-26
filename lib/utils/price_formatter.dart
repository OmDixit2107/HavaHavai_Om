import 'package:intl/intl.dart';

class PriceFormatter {
  static String formatPrice(double price) {
    final formatter = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
      locale: 'en_IN',
    );
    return formatter.format(price);
  }

  // Format with strikethrough price (original price)
  static String formatOriginalPrice(double price) {
    final formatter = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
      locale: 'en_IN',
    );
    return formatter.format(price);
  }

  // Calculate and format discount percentage
  static String formatDiscountPercentage(double discountPercentage) {
    return '${discountPercentage.toStringAsFixed(2)}% OFF';
  }
}
