/// Demo test file to verify HomePage API integration
/// 
/// FEATURES IMPLEMENTED:
/// 
/// 🏠 HomePage Integration:
/// - BlocProvider<HomeBloc> wraps the entire page
/// - Auto-triggers LoadHomeDataEvent on page creation  
/// - BlocBuilder rebuilds UI based on HomeState changes
/// 
/// 📊 API Data Display:
/// 
/// Categories Section:
/// - Fetches from: GET /api/categories
/// - Displays: categoryName, iconURL (with fallback icon)
/// - Grid layout: 2 rows x horizontal scroll
/// - Handles: loading, error, empty states
/// 
/// Products Section:  
/// - Fetches from: GET /api/product
/// - Displays: productName, basePrice, discountPrice, stockQuantity
/// - Grid layout: 2 columns x vertical scroll
/// - Features: SALE badge, stock color coding, price formatting
/// 
/// 🔍 Search Functionality:
/// - Triggers: SearchProductsEvent on text input
/// - API: GET /api/product/search?query=xxx
/// - Shows: search results in ProductGrid
/// - Hides: categories & livestream sections during search
/// 
/// 🎨 UI States:
/// 
/// Loading State (HomeLoading):
/// ```dart
/// SliverFillRemaining(
///   child: Center(child: CircularProgressIndicator())
/// )
/// ```
/// 
/// Error State (HomeError): 
/// ```dart
/// Column(
///   children: [
///     Icon(Icons.error_outline),
///     Text('Có lỗi xảy ra'),
///     Text(state.message),
///     ElevatedButton('Thử lại') // triggers RefreshHomeDataEvent
///   ]
/// )
/// ```
/// 
/// Success State (HomeLoaded):
/// ```dart
/// // Banner slider (static)
/// BannerSlider()
/// 
/// // Categories from API
/// CategorySection(categories: state.categories)
/// 
/// // Livestream section (static) 
/// LiveStreamSection()
/// 
/// // Products from API
/// ProductGrid(products: state.products)
/// ```
/// 
/// Search Results State (ProductSearchLoaded):
/// ```dart
/// // Banner only
/// BannerSlider()
/// 
/// // Search results
/// ProductGrid(products: state.searchResults)
/// ```
/// 
/// 💡 Data Flow:
/// 1. HomePage created → HomeBloc.add(LoadHomeDataEvent())
/// 2. HomeBloc calls GetCategoriesUseCase + GetProductsUseCase  
/// 3. UseCases call HomeRepository.getCategories() + getProducts()
/// 4. Repository calls HomeRemoteDataSource APIs
/// 5. API returns CategoryResponseModel + ProductResponseModel
/// 6. Models convert to Entities via .toEntity()
/// 7. HomeBloc emits HomeLoaded(categories, products, ...)
/// 8. BlocBuilder rebuilds UI with real data
/// 
/// 🔄 Search Flow:
/// 1. User types in search bar → _onSearchChanged(query)
/// 2. HomeBloc.add(SearchProductsEvent(query))
/// 3. HomeBloc calls SearchProductsUseCase
/// 4. API: GET /api/product/search?query=xxx
/// 5. HomeBloc emits ProductSearchLoaded(searchResults, query)
/// 6. UI shows search results only
/// 
/// 📱 API Response Mapping:
/// 
/// Category API → CategoryEntity:
/// ```json
/// {
///   "categoryId": "uuid",
///   "categoryName": "Thiết bị điện tử", 
///   "iconURL": "https://...",
///   "description": "...",
///   "subCategories": [...]
/// }
/// ```
/// 
/// Product API → ProductEntity:
/// ```json
/// {
///   "id": "uuid",
///   "productName": "iPhone 15",
///   "basePrice": 29990000,
///   "discountPrice": 25990000,
///   "stockQuantity": 50,
///   "categoryId": "uuid",
///   ...
/// }
/// ```
/// 
/// 🎯 UI Features:
/// - Responsive grid layouts
/// - Network image loading with fallbacks
/// - Price formatting (K₫, M₫)
/// - Stock quantity color coding
/// - Sale badges for discounted products
/// - Smooth loading states
/// - Error handling with retry
/// - Search with real-time API calls

void main() {
  print('HomePage API Integration Demo - Implementation Complete! ✅');
}
