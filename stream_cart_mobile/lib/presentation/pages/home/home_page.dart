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
  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      context.read<HomeBloc>().add(SearchProductsEvent(query));
    } else {
      context.read<HomeBloc>().add(LoadHomeDataEvent());
    }
  }

  void _onCartPressed() {
    Navigator.pushNamed(context, AppRouter.cart);
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => getIt<HomeBloc>()..add(LoadHomeDataEvent()),
      child: Scaffold(
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
                    backgroundColor: Colors.white,
                    elevation: 1,
                    toolbarHeight: 80,
                    automaticallyImplyLeading: false,
                    flexibleSpace: Container(
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
                              onChanged: _onSearchChanged,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Cart icon
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: _onCartPressed,
                              icon: Stack(
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.deepPurple,
                                    size: 24,
                                  ),
                                  // Badge for cart count
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
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
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Có lỗi xảy ra',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      ),
                    ),                  // Success state - show content
                  if (state is HomeLoaded || state is ProductSearchLoaded) ...[
                    // Banner/Advertisement section
                    const SliverToBoxAdapter(
                      child: BannerSlider(),
                    ),

                    // Categories section - only show when not searching
                    if (state is HomeLoaded)
                      SliverToBoxAdapter(
                        child: CategorySectionWidget(categories: state.categories),
                      ),

                    // Livestream section - only show when not searching
                    if (state is HomeLoaded)
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
                              state is ProductSearchLoaded
                                  ? 'Kết quả tìm kiếm'
                                  : 'Tất cả sản phẩm',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            if (state is HomeLoaded)
                              TextButton(
                                onPressed: () {
                                  // TODO: Navigate to all products page
                                },
                                child: const Text(
                                  'Xem tất cả',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w500,
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
                        products: state is HomeLoaded
                            ? state.products
                            : (state as ProductSearchLoaded).searchResults,
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
