import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/dependency_injection.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_event.dart';
import '../../blocs/home/home_state.dart';
import '../../widgets/common/custom_search_bar.dart';
import '../../widgets/home/banner_slider.dart';
import '../../widgets/home/category_section_fix.dart';
import '../../widgets/home/livestream_section.dart';
import '../../widgets/home/product_grid.dart';
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

  void _onSearchTapped() {
    Navigator.pushNamed(context, AppRouter.search);
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
                  // Header with search and cart
                  SliverAppBar(
                    floating: true,
                    pinned: false,
                    snap: true,
                    backgroundColor: const Color(0xFF4CAF50),
                    elevation: 0,
                    toolbarHeight: 80,
                    automaticallyImplyLeading: false,
                    flexibleSpace: Container(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding,
                        vertical: 8,
                      ),
                      child: Row(
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
                          const SizedBox(width: 12),
                          // Cart icon
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              onPressed: _onCartPressed,
                              icon: Stack(
                                children: [
                                  const Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  // Badge for cart count
                                  Positioned(
                                    right: 0,
                                    top: 0,
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
                        ],
                      ),
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
                    // Banner/Advertisement section
                    const SliverToBoxAdapter(
                      child: BannerSlider(),
                    ),

                    // Categories section
                    SliverToBoxAdapter(
                      child: CategorySectionWidget(categories: state.categories),
                    ),

                    // Livestream section
                    const SliverToBoxAdapter(
                      child: LiveStreamSection(),
                    ),

                    // Products section header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tất cả sản phẩm',
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
                      child: ProductGrid(
                        products: state.products,
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
