import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/di/dependency_injection.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_state.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/common/auth_guard.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentBottomNavIndex = 2;

  @override
  void initState() {
    super.initState();
    _checkAndLoadProfile();
  }

  Future<void> _checkAndLoadProfile() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess || authState is AuthAuthenticated) {
      final storageService = getIt<StorageService>();
      final token = await storageService.getAccessToken(); 
      context.read<ProfileBloc>().add(LoadUserProfileEvent());
    }
  }

  void _onBottomNavTap(int index) {
    if (index == _currentBottomNavIndex) return;
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, AppRouter.livestreamList, (r) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (r) => false);
        break;
      case 2:
        break;
    }
  }

  void _checkAuthAndNavigate(BuildContext context, VoidCallback onAuthorized, String message) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess || authState is AuthAuthenticated) {
      onAuthorized();
    } else {
      showLoginRequiredDialog(context, message: message);
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

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Đăng xuất',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Bạn có chắc muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Hủy',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            child: const Text(
              'Đăng xuất',
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trang cá nhân',
          style: TextStyle(
            color: Color(0xFFB0F847),
            fontSize: 16,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF202328),
          ),
        ),
        actions: [
          // Chat icon
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: _onChatPressed,
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFFB0F847),
                    size: 22,
                  ),
                ),
                // Badge for unread messages
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5722),
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
          // Cart icon
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                int itemCount = 0;
                if (cartState is CartLoaded) {
                  itemCount = cartState.allItems.fold<int>(0, (sum, item) => sum + item.quantity);
                }

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      onPressed: _onCartPressed,
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Color(0xFFB0F847),
                        size: 22,
                      ),
                    ),
                    // Badge for cart items count - only show if itemCount > 0
                    if (itemCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 248, 132, 55),
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
                          child: Text(
                            itemCount > 99 ? '99+' : '$itemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          // Settings icon
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                // TODO: Navigate to settings
              },
              icon: const Icon(
                Icons.settings_outlined,
                color: Color(0xFFB0F847),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  // Profile header
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  
                  // Menu items
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Thông tin cá nhân',
                    onTap: () {
                      _checkAuthAndNavigate(context, () {
                        Navigator.pushNamed(context, AppRouter.profileDetail);
                      }, 'Bạn cần đăng nhập để xem thông tin cá nhân');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Đơn hàng của tôi',
                    onTap: () {
                      _checkAuthAndNavigate(context, () {
                        Navigator.pushNamed(context, AppRouter.orders);
                      }, 'Bạn cần đăng nhập để xem đơn hàng');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.favorite_outline,
                    title: 'Sản phẩm yêu thích',
                    onTap: () {
                      _checkAuthAndNavigate(context, () {
                        // TODO: Navigate to favorites
                      }, 'Bạn cần đăng nhập để xem sản phẩm yêu thích');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Địa chỉ giao hàng',
                    onTap: () {
                      _checkAuthAndNavigate(context, () {
                        Navigator.pushNamed(context, AppRouter.addressList);
                      }, 'Bạn cần đăng nhập để quản lý địa chỉ giao hàng');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.payment_outlined,
                    title: 'Phương thức thanh toán',
                    onTap: () {
                      _checkAuthAndNavigate(context, () {
                        // TODO: Navigate to payment methods
                      }, 'Bạn cần đăng nhập để quản lý phương thức thanh toán');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Hỗ trợ',
                    onTap: () {
                      // TODO: Navigate to support
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'Về chúng tôi',
                    onTap: () {
                      // TODO: Navigate to about
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Logout button - only show when logged in
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      if (authState is AuthSuccess || authState is AuthAuthenticated) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _logout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF202328),
                              foregroundColor: const Color(0xFFB0F847),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(
                                  color: Color(0xFFB0F847),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Color(0xFFB0F847),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Đăng xuất',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFB0F847),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Show login button when not logged in
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRouter.login);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF202328),
                              foregroundColor: Color(0xFFB0F847),
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.login,
                                  color: Color(0xFFB0F847),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFB0F847),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // Nếu chưa đăng nhập, hiển thị UI cho chưa đăng nhập
        if (authState is! AuthSuccess && authState is! AuthAuthenticated) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF202328),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xFFB0F847),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chưa đăng nhập',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF202328),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Vui lòng đăng nhập để xem thông tin',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF202328),
                      foregroundColor: Color(0xFFB0F847),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
        if (state is ProfileLoading) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4CAF50),
                  Color(0xFF66BB6A),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đang tải...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        
        if (state is ProfileError) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF2E7D32).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        color: Color(0xFF2E7D32),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lỗi tải dữ liệu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.message,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (state.message.contains('đăng nhập lại')) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRouter.login,
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadUserProfileEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Thử lại',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }
        
        if (state is ProfileLoaded) {
          final user = state.profile;
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4CAF50),
                  Color(0xFF66BB6A),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(33),
                    child: user.avatarURL != null && user.avatarURL!.isNotEmpty
                        ? Image.network(
                            user.avatarURL!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 35,
                              );
                            },
                          )
                        : const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 35,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullname.isNotEmpty ? user.fullname : user.username,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Đã xác thực',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        
        // Default state - not logged in
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF4CAF50),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chưa đăng nhập',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Vui lòng đăng nhập để xem thông tin',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
          },
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4CAF50),
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey.shade400,
          size: 16,
        ),
      ),
    );
  }
}
