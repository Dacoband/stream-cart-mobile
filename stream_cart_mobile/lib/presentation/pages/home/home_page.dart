import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/dependency_injection.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_event.dart';
import '../../blocs/home/home_state.dart';
import '../../widgets/common/custom_search_bar.dart';
import '../../widgets/home/livestream_section.dart';
import '../../widgets/home/product_grid.dart';
import '../../widgets/home/flash_sale_section.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int _currentBottomNavIndex = 1; 

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0: // Live
        Navigator.pushNamed(context, AppRouter.livestreamList);
        break;
      case 1: 
        break;
      case 2: // Profile
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  void _onCartPressed() {
    Navigator.pushNamed(context, AppRouter.cart);
  }

  void _onChatPressed() {
    // TODO: Navigate to chat page when API is ready
    print('Chat button pressed - API integration pending');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng chat đang phát triển'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onSearchTapped() {
    Navigator.pushNamed(context, AppRouter.search);
  }

  Widget _buildCategoryItem(dynamic category) {
    // Safe access to category properties
    String categoryName;
    String? iconUrl;
    
    // Handle different category data structures
    if (category is Map<String, dynamic>) {
      // Handle Map data (fallback case)
      categoryName = category['categoryName'] ??  
                    category['name'] ?? 
                    category['title'] ?? 
                    category['category_name'] ??
                    category['label'] ??
                    'Unknown';
      iconUrl = category['iconURL'] ?? category['iconUrl'];
      print('Category from Map: $category -> name: $categoryName');
    } else if (category is String) {
      // Handle simple string category
      categoryName = category;
      iconUrl = null;
    } else {
      // Handle entity objects (this should be the main case for API data)
      try {
        // Try to access properties that should exist on CategoryEntity
        categoryName = category.categoryName ?? category.toString();
        iconUrl = category.iconURL;
        print('Category from Entity: ${category.runtimeType} -> name: $categoryName, iconURL: $iconUrl');
      } catch (e) {
        categoryName = category?.toString() ?? 'Unknown';
        iconUrl = null;
        print('Error accessing category entity: $e');
      }
    }
    
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to category page
        print('Tapped on category: $categoryName');
      },
      child: Container(
        width: 80, // Increased width for better display in larger header
        padding: const EdgeInsets.all(6), // Increased padding
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10), // Slightly more rounded
          // Removed border
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
          children: [
            // Category icon
            Container(
              width: 32, // Larger icon container for bigger header
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32), // Make it fully rounded (circular)
              ),
              child: iconUrl != null && iconUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.network(
                        iconUrl,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to default icon if image fails to load
                          return Icon(
                            _getCategoryIcon(categoryName),
                            color: const Color(0xFF4CAF50),
                            size: 20, // Larger icon size for bigger container
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Icon(
                            _getCategoryIcon(categoryName),
                            color: const Color(0xFF4CAF50),
                            size: 20, // Larger icon size for bigger container
                          );
                        },
                      ),
                    )
                  : Icon(
                      _getCategoryIcon(categoryName),
                      color: const Color(0xFF4CAF50),
                      size: 20, // Larger icon size for bigger container
                    ),
            ),
            const SizedBox(height: 4), // Increased spacing between icon and text
            // Category name
            Flexible(
              child: Text(
                categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11, // Larger font for better readability in bigger header
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Allow 2 lines for longer names
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    // Map category names to icons - matching API data
    switch (categoryName.toLowerCase()) {
      case 'giày':
      case 'shoes':
        return Icons.sports_basketball;
      case 'thời trang nữ':
      case 'fashion':
        return Icons.checkroom;
      case 'thiết bị điện tử': // Match API data exactly
      case 'thiết bị điện':
      case 'electronics':
        return Icons.electrical_services;
      case 'laptop': // For subcategory
        return Icons.laptop;
      case 'thể thao':
      case 'sports':
        return Icons.sports_soccer;
      case 'sách':
      case 'books':
        return Icons.book;
      case 'mỹ phẩm':
      case 'cosmetics':
        return Icons.face_retouching_natural;
      default:
        return Icons.category;
    }
  }

  List<String> _getDefaultCategories() {
    return [
      'Thời trang nữ',
      'Giày',
      'Thiết bị điện',
      'Thể thao',
      'Sách',
      'Mỹ phẩm',
    ];
  }

  Widget _buildCartIcon() {
    return SizedBox(
      width: 48, // Fixed width to prevent squashing
      height: 48, // Fixed height to maintain aspect ratio
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _onCartPressed,
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 22, // Slightly smaller to fit better
                ),
                // Badge for cart count
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '3', // TODO: Get cart count from BLoC
                      style: TextStyle(
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
          ),
        ),
      ),
    );
  }

  Widget _buildChatIcon() {
    return SizedBox(
      width: 48, // Fixed width to prevent squashing
      height: 48, // Fixed height to maintain aspect ratio
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _onChatPressed,
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 22, // Slightly smaller to fit better
                ),
                // Badge for unread messages
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5722), // Orange color for notifications
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '5', // TODO: Get unread message count from API
                      style: TextStyle(
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
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(HomeState state) {
    // Get categories from API first, fallback to default
    List<dynamic> categoriesToShow = [];
    
    if (state is HomeLoaded && state.categories.isNotEmpty) {
      categoriesToShow = state.categories;
      print('Using API categories: ${state.categories.length} items');
    } else {
      categoriesToShow = _getDefaultCategories();
      print('Using default categories: ${categoriesToShow.length} items');
    }
    
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4), // Slightly increased padding
      itemCount: categoriesToShow.length,
      separatorBuilder: (context, index) => const SizedBox(width: 12), // Increased spacing between items
      itemBuilder: (context, index) {
        final category = categoriesToShow[index];
        return _buildCategoryItem(category);
      },
    );
  }

  Widget _buildCompactBanner() {
    final List<Map<String, String>> banners = [
      {
        'title': 'Flash Sale 50%',
        'subtitle': 'Giảm giá sốc cho tất cả sản phẩm',
        'color': 'purple',
      },
      {
        'title': '20.7 DEAL ĐẸP GIỜ VÀNG',
        'subtitle': 'ƯU NHẤT 7H - 24H NGÀY 20.7',
        'color': 'orange',
      },
      {
        'title': 'Miễn phí vận chuyển',
        'subtitle': 'Cho đơn hàng từ 500k',
        'color': 'green',
      },
    ];

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getBannerBackgroundColor(banner['color']!),
                  _getBannerBackgroundColor(banner['color']!).withOpacity(0.8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    banner['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner['subtitle']!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Mua ngay',
                      style: TextStyle(
                        color: _getBannerBackgroundColor(banner['color']!),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getBannerBackgroundColor(String colorName) {
    switch (colorName) {
      case 'purple':
        return Colors.deepPurple.shade400;
      case 'orange':
        return Colors.orange.shade400;
      case 'green':
        return Colors.green.shade400;
      case 'blue':
        return Colors.blue.shade400;
      default:
        return Colors.deepPurple.shade400;
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => getIt<HomeBloc>()..add(LoadHomeDataEvent()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5), // Light background
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Header with search, cart and categories
                  SliverAppBar(
                    floating: true,
                    pinned: false,
                    snap: true,
                    backgroundColor: const Color(0xFF4CAF50),
                    elevation: 0,
                    toolbarHeight: 280, // Increase height significantly for full category display
                    automaticallyImplyLeading: false,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        // Get screen width for responsive design
                        final screenWidth = MediaQuery.of(context).size.width;
                        final isSmallScreen = screenWidth < 360;
                        
                        // Calculate available height and adjust category height dynamically
                        final availableHeight = constraints.maxHeight;
                        final searchBarHeight = 48.0; // Fixed search bar height
                        final bannerHeight = isSmallScreen ? 100.0 : 120.0; // Responsive banner height
                        final padding = 24.0; // Total vertical padding
                        final spacing = 20.0; // Total spacing between elements
                        
                        // Ensure minimum space for categories
                        final categoryHeight = (availableHeight - searchBarHeight - bannerHeight - padding - spacing).clamp(60.0, 90.0);
                        
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF4CAF50),
                                Color(0xFF66BB6A),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.defaultPadding,
                            vertical: 12, // Increased vertical padding
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Search bar and action icons row
                              Row(
                                children: [
                                  // Search bar
                                  Expanded(
                                    child: CustomSearchBar(
                                      controller: _searchController,
                                      hintText: 'Tìm kiếm sản phẩm...',
                                      readOnly: true,
                                      onTap: _onSearchTapped,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Action icons container
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Chat icon
                                      _buildChatIcon(),
                                      const SizedBox(width: 8),
                                      // Cart icon
                                      _buildCartIcon(),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12), // Increased spacing after search bar
                              // Banner section
                              SizedBox(
                                height: bannerHeight,
                                child: _buildCompactBanner(),
                              ),
                              const SizedBox(height: 12), // Increased spacing before categories
                              // Categories list with dynamic height
                              Flexible(
                                child: SizedBox(
                                  height: categoryHeight,
                                  child: _buildCategoryList(state),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Loading indicator when loading
                  if (state is HomeLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),

                  // Error state
                  if (state is HomeError)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: const Color(0xFF2E7D32),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Có lỗi xảy ra',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<HomeBloc>().add(RefreshHomeDataEvent());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Thử lại',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),                  // Success state - show content
                  if (state is HomeLoaded) ...[
                    // Livestream section
                    const SliverToBoxAdapter(
                      child: LiveStreamSection(),
                    ),

                    // Flash Sale section
                    const SliverToBoxAdapter(
                      child: FlashSaleSection(),
                    ),

                    // Products section header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Đề xuất cho bạn',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Navigate to all products page
                              },
                              child: const Text(
                                'Xem tất cả',
                                style: TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Products grid
                    SliverToBoxAdapter(
                      child: Builder(
                        builder: (context) {
                          // Debug: Print productImages being passed to ProductGrid
                          print('🏠 HomePage - Passing productImages to ProductGrid: ${state.productImages.keys.toList()}');
                          print('🏠 HomePage - productImages count: ${state.productImages.length}');
                          print('🏠 HomePage - products count: ${state.products.length}');
                          
                          return ProductGrid(
                            key: ValueKey('product_grid_${state.productImages.length}'),
                            products: state.products,
                            productImages: state.productImages,
                          );
                        },
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentBottomNavIndex,
          onTap: _onBottomNavTap,
        ),
      ),
    );
  }
}
