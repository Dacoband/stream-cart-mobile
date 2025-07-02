import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentBottomNavIndex = 2; // Profile is index 2

  @override
  void initState() {
    super.initState();
    // TODO: Load user profile using /api/auth/me
    // context.read<ProfileBloc>().add(LoadUserProfileEvent());
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0: // Live
        Navigator.pushNamed(context, AppRouter.livestreamList);
        break;
      case 1: // Home
        Navigator.pushNamed(context, AppRouter.home);
        break;
      case 2: // Profile
        // Already on profile, do nothing
        break;
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.login,
                (route) => false,
              );
            },
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: Colors.red),
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
        title: const Text('Trang cá nhân'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigate to settings
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
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
                    // TODO: Navigate to edit profile
                  },
                ),
                _buildMenuItem(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Đơn hàng của tôi',
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.orders);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.favorite_outline,
                  title: 'Sản phẩm yêu thích',
                  onTap: () {
                    // TODO: Navigate to favorites
                  },
                ),
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Địa chỉ giao hàng',
                  onTap: () {
                    // TODO: Navigate to addresses
                  },
                ),
                _buildMenuItem(
                  icon: Icons.payment_outlined,
                  title: 'Phương thức thanh toán',
                  onTap: () {
                    // TODO: Navigate to payment methods
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
                
                // Logout button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red.shade200),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text(
                          'Đăng xuất',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.person,
              color: Colors.deepPurple,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Người dùng', // TODO: Get from user profile
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'user@example.com', // TODO: Get from user profile
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Đã xác thực',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Edit button
          IconButton(
            onPressed: () {
              // TODO: Navigate to edit profile
            },
            icon: Icon(
              Icons.edit_outlined,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.grey.shade600,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey.shade400,
          size: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.white,
      ),
    );
  }
}
