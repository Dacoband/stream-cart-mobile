import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routing/app_router.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_state.dart';
import '../../blocs/profile/profile_event.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            color: Color(0xFFB0F847),
            fontSize: 16,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF202328),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF202328),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFB0F847)),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: IconButton(
                  onPressed: state is ProfileLoaded
                      ? () async {
                          final result = await Navigator.pushNamed(
                            context,
                            AppRouter.editProfile,
                            arguments: state.profile,
                          );
                          if (result != null) {
                            context.read<ProfileBloc>().add(LoadUserProfileEvent());
                          }
                        }
                      : null,
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFFB0F847),
                  ),
                  tooltip: 'Chỉnh sửa thông tin',
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4CAF50),
                ),
              );
            }

            if (state is ProfileError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Có lỗi xảy ra',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
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
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Quay lại',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ProfileLoaded) {
              final user = state.profile;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    // Profile Header Card
                    _buildProfileHeader(user),
                    const SizedBox(height: 24),
                    
                    // Account Information Section
                    _buildAccountInfoSection(user),
                    const SizedBox(height: 16),
                    
                    // Contact Information Section
                    _buildContactInfoSection(user),
                    const SizedBox(height: 16),
                    
                    // Account Status Section
                    _buildAccountStatusSection(user),
                    const SizedBox(height: 16),
                    
                    // System Information Section
                    _buildSystemInfoSection(user),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }

            return const Center(
              child: Text(
                'Không có dữ liệu',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4CAF50),
            Color(0xFF66BB6A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 3,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(47),
              child: user.avatarURL != null && user.avatarURL!.isNotEmpty
                  ? Image.network(
                      user.avatarURL!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 50,
                        );
                      },
                    )
                  : const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Name
          Text(
            user.fullname.isNotEmpty ? user.fullname : user.username,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          // Email
          Text(
            user.email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          
          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              _getRoleDisplayName(user.role),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoSection(user) {
    return _buildSection(
      title: 'Thông tin tài khoản',
      icon: Icons.account_circle_outlined,
      children: [
        _buildInfoRow('Tên đăng nhập', user.username),
        _buildInfoRow('Họ và tên', user.fullname.isNotEmpty ? user.fullname : 'Chưa cập nhật'),
        if (user.shopId != null)
          _buildInfoRow('ID cửa hàng', user.shopId!),
      ],
    );
  }

  Widget _buildContactInfoSection(user) {
    return _buildSection(
      title: 'Thông tin liên hệ',
      icon: Icons.contact_phone_outlined,
      children: [
        _buildInfoRow('Email', user.email),
        _buildInfoRow('Số điện thoại', user.phoneNumber.isNotEmpty ? user.phoneNumber : 'Chưa cập nhật'),
      ],
    );
  }

  Widget _buildAccountStatusSection(user) {
    return _buildSection(
      title: 'Trạng thái tài khoản',
      icon: Icons.security_outlined,
      children: [
        _buildStatusRow('Tài khoản hoạt động', user.isActive),
        _buildStatusRow('Đã xác thực', user.isVerified),
        _buildInfoRow('Mức độ hoàn thiện', '${(user.completeRate * 100).toInt()}%'),
        _buildInfoRow('Vai trò', _getRoleDisplayName(user.role)),
      ],
    );
  }

  Widget _buildSystemInfoSection(user) {
    return _buildSection(
      title: 'Thông tin hệ thống',
      icon: Icons.info_outline,
      children: [
        _buildInfoRow('Ngày đăng ký', _formatDateTime(user.registrationDate)),
        if (user.lastLoginDate != null)
          _buildInfoRow('Đăng nhập gần nhất', _formatDateTime(user.lastLoginDate!)),
        if (user.lastModifiedAt != null)
          _buildInfoRow('Cập nhật gần nhất', _formatDateTime(user.lastModifiedAt!)),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
          
          // Section Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? Colors.green.shade300 : Colors.red.shade300,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? Icons.check_circle : Icons.cancel,
                        color: isActive ? Colors.green.shade700 : Colors.red.shade700,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isActive ? 'Có' : 'Không',
                        style: TextStyle(
                          fontSize: 12,
                          color: isActive ? Colors.green.shade700 : Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleDisplayName(int role) {
    switch (role) {
      case 1:
        return 'Khách hàng';
      case 2:
        return 'Người bán';
      case 3:
        return 'Kiểm duyệt viên';
      case 5:
        return 'Quản lý vận hành';
      case 6:
        return 'Quản trị viên IT';
      default:
        return 'Không xác định';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
