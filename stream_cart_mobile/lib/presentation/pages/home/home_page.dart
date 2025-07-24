import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/dependency_injection.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_event.dart';
import '../../blocs/home/home_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/common/custom_search_bar.dart';
import '../../widgets/home/livestream_section.dart';
import '../../widgets/home/product_grid.dart';
import '../../widgets/home/flash_sale_section.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/common/auth_guard.dart';
import '../../widgets/common/cart_icon_badge.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int _currentBottomNavIndex = 1; 
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrolled = _scrollController.hasClients && _scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
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
      case 0: 
        Navigator.pushNamed(context, AppRouter.livestreamList);
        break;
      case 1: 
        break;
      case 2: 
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  void _onCartPressed() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess || authState is AuthAuthenticated) {
      Navigator.pushNamed(context, AppRouter.cart);
    } else {
      showLoginRequiredDialog(context, message: 'Bạn cần đăng nhập để xem giỏ hàng');
    }
  }

  void _onChatPressed() {
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
    String categoryName;
    String? iconUrl;

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
      try {
        categoryName = category.categoryName ?? category.toString();
        iconUrl = category.iconURL;
      } catch (e) {
        categoryName = category?.toString() ?? 'Unknown';
        iconUrl = null;
        print('Error accessing category entity: $e');
      }
    }
    
    return GestureDetector(
      onTap: () {
        // Navigate to category detail page
        if (category != null) {
          String? categoryId;
          
          // Extract categoryId based on the category type
          if (category is Map<String, dynamic>) {
            categoryId = category['categoryId'] ?? category['id'];
          } else {
            try {
              categoryId = category.categoryId;
            } catch (e) {
              print('Error getting categoryId: $e');
            }
          }
          
          if (categoryId != null && categoryId.isNotEmpty) {
            Navigator.of(context).pushNamed(
              AppRouter.categoryDetail,
              arguments: {
                'categoryId': categoryId,
                'categoryName': categoryName,
              },
            ).then((result) {
              print('✅ Navigation completed');
            }).catchError((error) {
              print('❌ Navigation error: $error');
            });
          } else {
            print('❌ Cannot navigate: categoryId is null or empty');
          }
        }
      },
      child: Container(
        width: 80,
        height: 60, 
        padding: const EdgeInsets.all(6), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            // Category icon
            Container(
              width: 32, 
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13), 
              ),
              child: Center(
                child: iconUrl != null && iconUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.network(
                          iconUrl,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              _getCategoryIcon(categoryName),
                              color: const Color(0xFF4CAF50),
                              size: 30,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Icon(
                              _getCategoryIcon(categoryName),
                              color: const Color(0xFF4CAF50),
                              size: 30, 
                            );
                          },
                        ),
                      )
                    : Icon(
                        _getCategoryIcon(categoryName),
                        color: const Color(0xFF4CAF50),
                        size: 30,
                      ),
              ),
            ),
            const SizedBox(height: 4),
            // Category name
            Expanded(
              child: Text(
                categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                ),
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
        child: CartIconBadge(
          onTap: _onCartPressed,
          iconColor: Colors.white,
          badgeColor: const Color(0xFF2E7D32),
        ),
      ),
    );
  }

  Widget _buildChatIcon() {
    return SizedBox(
      width: 48, // Fixed width to prevent squashing
      height: 48, // Fixed height to maintain aspect ratio
      child: Container(
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
    } else {
      categoriesToShow = _getDefaultCategories();
    }
    
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4), 
      itemCount: categoriesToShow.length,
      separatorBuilder: (context, index) => const SizedBox(width: 12), 
      itemBuilder: (context, index) {
        final category = categoriesToShow[index];
        return _buildCategoryItem(category);
      },
    );
  }

  Widget _buildFullBanner() {
    final List<Map<String, String>> banners = [
      {
        'title': 'TUỔI TRẺ KHỎE ĐẸP',
        'subtitle': 'CÙNG STREAM CARD',
        'image': 'assets/images/banner1.jpg',
        'buttonText': 'ĐẶT THÔNG BÁO NGAY!',
      },
      {
        'title': 'XEM LIVESTREAM',
        'subtitle': 'SẴN SẮP SẴN',
        'image': 'assets/images/banner2.jpg',
        'buttonText': 'JOIN NOW',
      },
      {
        'title': 'MEGA LIVE BLACK FRIDAY',
        'subtitle': 'STREAMCARD',
        'image': 'assets/images/banner3.jpg',
        'buttonText': 'KHÁM PHÁ NGAY',
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(banner['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
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
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        banner['subtitle']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          banner['buttonText']!,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompactChatIcon() {
    return SizedBox(
      width: 36,
      height: 36,
      child: Container(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _onChatPressed,
            borderRadius: BorderRadius.circular(12),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCartIcon() {
    return SizedBox(
      width: 36,
      height: 36,
      child: Container(
        child: CartIconBadge(
          onTap: _onCartPressed,
          iconColor: Colors.white,
          badgeColor: const Color(0xFF2E7D32),
        ),
      ),
    );
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
                  // Search bar - always visible, becomes pinned when scrolled
                  SliverAppBar(
                    floating: true,
                    pinned: _isScrolled,
                    snap: !_isScrolled,
                    backgroundColor: const Color(0xFF4CAF50),
                    elevation: _isScrolled ? 2 : 0,
                    toolbarHeight: 60,
                    automaticallyImplyLeading: false,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF4CAF50),
                            Color(0xFF66BB6A),
                          ],
                        ),
                        borderRadius: _isScrolled 
                          ? null 
                          : const BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SafeArea(
                        bottom: false,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomSearchBar(
                                controller: _searchController,
                                hintText: 'Tìm kiếm sản phẩm...',
                                readOnly: true,
                                onTap: _onSearchTapped,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _isScrolled ? _buildCompactChatIcon() : _buildChatIcon(),
                                const SizedBox(width: 8),
                                _isScrolled ? _buildCompactCartIcon() : _buildCartIcon(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Banner and Categories section - hidden when scrolled
                  if (!_isScrolled) ...[
                    // Small spacing to create seamless effect
                    SliverToBoxAdapter(
                      child: Container(
                        height: 2,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF4CAF50),
                              Color(0xFF66BB6A),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
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
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Column(
                          children: [
                            // Banner section
                            SizedBox(
                              height: 120,
                              child: _buildFullBanner(),
                            ),
                            const SizedBox(height: 16),
                            // Categories section
                            SizedBox(
                              height: 80,
                              child: _buildCategoryList(state),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

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
