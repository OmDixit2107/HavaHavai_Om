# Hava Havai Shopping Cart

A Flutter e-commerce application with product catalog, shopping cart functionality and theme switching capability.

## Features

### Core Features

- **Product Catalog**: Display products fetched from [DummyJSON API](https://dummyjson.com/products)
- **Pagination**: Load products in batches as the user scrolls through the catalog
- **Shopping Cart**: Add products to cart, view cart contents, and modify quantities
- **Price Calculations**:
  - Display discounted prices based on product discount percentages
  - Calculate total cart price based on product quantities
- **Responsive Design**: Works on various screen sizes with proper layouts
- **Theme Switching**: Toggle between light and dark mode

### User Experience

- Pull-to-refresh functionality to reload products
- Intuitive product cards with clear pricing and discount information
- "Add" button on each product card for quick addition to cart
- Cart badge indicating number of items in cart
- Snackbar notifications when products are added to cart

## Architecture

### State Management

The application uses **Riverpod** for state management, implementing:

- Providers for maintaining application state
- NotifierProviders for complex state logic

### Project Structure

```
lib/
├── models/
│   ├── product.dart             # Product data model
│   └── cart_item.dart           # Cart item data model
├── providers/
│   ├── product_provider.dart    # Product state management
│   ├── cart_provider.dart       # Cart state management
│   └── theme_provider.dart      # Theme state management
├── repositories/
│   └── product_repository.dart  # API interaction and data fetching
├── screens/
│   ├── catalogue_screen.dart    # Main product listing screen
│   └── cart_screen.dart         # Cart contents screen
├── utils/
│   ├── price_formatter.dart     # Utility functions for price formatting
│   └── network_utils.dart       # HTTP client and API utilities
├── widgets/
│   ├── product_card.dart        # Product display card
│   ├── cart_item_widget.dart    # Cart item display
│   └── theme_toggle.dart        # Toggle for switching themes
└── main.dart                    # Application entry point
```

## Implementation Details

### API Integration

- Fetches product data from DummyJSON API
- Implements pagination to load products as needed
- Uses HTTP client for API communication

### Product Display

- Grid layout for product catalog
- Each product card shows:
  - Product image
  - Title and brand
  - Original price with discount percentage
  - Final discounted price
  - Add to cart button

### Cart Functionality

- Add products to cart
- Increment/decrement product quantities
- Remove products from cart
- Real-time total price calculation

### Theme Switching

- Toggle between light and dark mode
- Theme-responsive UI elements
- Persistent theme selection

## Technical Highlights

### Code Organization

- **Separation of Concerns**: Clear separation between data, logic, and UI
- **Reusable Components**: Widgets designed for reusability
- **Modular Architecture**: Independent modules that can be maintained separately

### Error Handling

- Graceful error handling for API requests
- Image loading error handling with fallback
- Boundary case handling for cart operations

### Performance Considerations

- Lazy loading of products with pagination
- Efficient state updates with Riverpod

## Development Best Practices

### Git Workflow

- Regular commits with descriptive messages
- Feature-based branching

### Code Standards

- Consistent naming conventions
- Proper code documentation
- SOLID principles application

## Creative Touches

### Theme Toggling

- Added a dynamic theme switching feature to enhance user experience
- Implemented a theme toggle button in the app bar
- Designed both light and dark themes with appropriate color palettes
- Made all UI components responsive to theme changes

### Visual Design

- Custom color scheme that's visually appealing
- Attention to detail in spacing and layout
- Smooth transitions between screens
- Responsive design for various screen sizes

## Future Enhancements

- User authentication and profiles
- Product details screen
- Favorites/wishlist functionality
- Order processing and history
- Product filtering and search
- Product categories and navigation
- Local storage for offline capability

## Getting Started

1. Ensure Flutter is installed on your system
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run the application with `flutter run`

## Dependencies

- `flutter_riverpod`: State management
- `http`: API requests
- `intl`: Formatting for prices
- `cached_network_image`: Efficient image loading

## Screenshots

[Include screenshots of your application here]

## License

This project is open-source and available under the MIT License.
"# HavaHavai_Om"
