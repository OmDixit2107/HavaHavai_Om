class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;
  final List<String> tags;
  final String sku;
  final double weight;
  final Map<String, double> dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<Map<String, dynamic>> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final Map<String, dynamic> meta;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
    required this.tags,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
  });

  double get discountedPrice {
    return price * (1 - discountPercentage / 100);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      // Convert price to double safely
      double parseDouble(dynamic value) {
        if (value is int) {
          return value.toDouble();
        } else if (value is double) {
          return value;
        } else if (value is String) {
          return double.tryParse(value) ?? 0.0;
        }
        return 0.0;
      }

      // Safely extract images list
      List<String> parseImages(dynamic images) {
        if (images is List) {
          return images.map((item) => item.toString()).toList();
        }
        return [];
      }

      return Product(
        id: json['id'] ?? 0,
        title: json['title'] ?? 'Unknown Product',
        description: json['description'] ?? 'No description available',
        price: parseDouble(json['price']),
        discountPercentage: parseDouble(json['discountPercentage']),
        rating: parseDouble(json['rating']),
        stock: json['stock'] ?? 0,
        brand: json['brand'] ?? 'Unknown Brand',
        category: json['category'] ?? 'Uncategorized',
        thumbnail: json['thumbnail'] ?? 'https://via.placeholder.com/150',
        images: parseImages(json['images']),
        tags: List<String>.from(json['tags'] as List),
        sku: json['sku'] as String,
        weight: parseDouble(json['weight']),
        dimensions: Map<String, double>.from(
          (json['dimensions'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, parseDouble(value)),
          ),
        ),
        warrantyInformation:
            json['warrantyInformation'] ?? 'No warranty information available',
        shippingInformation:
            json['shippingInformation'] ?? 'No shipping information available',
        availabilityStatus:
            json['availabilityStatus'] ?? 'Unknown availability',
        reviews: List<Map<String, dynamic>>.from(json['reviews'] as List),
        returnPolicy: json['returnPolicy'] ?? 'No return policy available',
        minimumOrderQuantity: json['minimumOrderQuantity'] ?? 1,
        meta: json['meta'] as Map<String, dynamic>,
      );
    } catch (e) {
      print('Error parsing product JSON: $e');
      print('Problematic JSON: $json');

      // Return a default product if parsing fails
      return Product(
        id: 0,
        title: 'Error Product',
        description: 'There was an error loading this product',
        price: 0.0,
        discountPercentage: 0.0,
        rating: 0.0,
        stock: 0,
        brand: 'Unknown',
        category: 'Error',
        thumbnail: 'https://via.placeholder.com/150',
        images: [],
        tags: [],
        sku: '',
        weight: 0.0,
        dimensions: {},
        warrantyInformation: 'No warranty information available',
        shippingInformation: 'No shipping information available',
        availabilityStatus: 'Unknown availability',
        reviews: [],
        returnPolicy: 'No return policy available',
        minimumOrderQuantity: 1,
        meta: {},
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
      'tags': tags,
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions,
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'reviews': reviews,
      'returnPolicy': returnPolicy,
      'minimumOrderQuantity': minimumOrderQuantity,
      'meta': meta,
    };
  }
}
