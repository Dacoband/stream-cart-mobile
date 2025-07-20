import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../../data/models/update_profile_model.dart';
import '../../../domain/entities/user_profile_entity.dart';
import '../../../core/services/image_upload_service.dart';
import '../../../core/di/dependency_injection.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfileEntity currentProfile;

  const EditProfilePage({
    Key? key,
    required this.currentProfile,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  final ImagePicker _imagePicker = ImagePicker();
  final ImageUploadService _imageUploadService = getIt<ImageUploadService>();
  
  String? _selectedImageUrl;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.currentProfile.fullname);
    _phoneController = TextEditingController(text: widget.currentProfile.phoneNumber);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      final updateRequest = UpdateProfileRequestModel(
        phoneNumber: _phoneController.text.trim(),
        fullname: _fullNameController.text.trim(),
        avatarURL: _selectedImageUrl ?? widget.currentProfile.avatarURL,
        role: widget.currentProfile.role,
        isActive: widget.currentProfile.isActive,
        isVerified: widget.currentProfile.isVerified,
        completeRate: widget.currentProfile.completeRate,
        shopId: widget.currentProfile.shopId,
      );

      context.read<ProfileBloc>().add(
        UpdateUserProfileEvent(
          userId: widget.currentProfile.id.toString(),
          request: updateRequest,
        ),
      );
    }
  }

  Future<void> _selectAndUploadImage() async {
    try {
      setState(() {
        _isUploadingImage = true;
      });

      // Show dialog để chọn camera hoặc gallery
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Chọn nguồn ảnh'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Chụp ảnh'),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Thư viện ảnh'),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      );

      if (source == null) {
        setState(() {
          _isUploadingImage = false;
        });
        return;
      }

      // Chọn ảnh từ source đã chọn
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        print('[EditProfilePage] Image selected: ${pickedFile.path}');
        
        // Upload ảnh
        final imageUrl = await _imageUploadService.uploadImage(pickedFile);
        
        if (imageUrl != null) {
          setState(() {
            _selectedImageUrl = imageUrl;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tải ảnh thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          
          print('[EditProfilePage] Image uploaded successfully: $imageUrl');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tải ảnh thất bại. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('[EditProfilePage] Error selecting/uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Có lỗi xảy ra khi tải ảnh. Vui lòng thử lại.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chỉnh sửa thông tin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật thông tin thành công!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, state.updatedProfile);
          } else if (state is ProfileUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      // Avatar section
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: (_selectedImageUrl ?? widget.currentProfile.avatarURL) != null && 
                                                  (_selectedImageUrl ?? widget.currentProfile.avatarURL)!.isNotEmpty
                                      ? NetworkImage(_selectedImageUrl ?? widget.currentProfile.avatarURL!)
                                      : null,
                                  child: (_selectedImageUrl ?? widget.currentProfile.avatarURL) == null || 
                                         (_selectedImageUrl ?? widget.currentProfile.avatarURL)!.isEmpty
                                      ? Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey[600],
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _isUploadingImage ? null : _selectAndUploadImage,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: _isUploadingImage 
                                            ? Colors.grey 
                                            : Theme.of(context).primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: _isUploadingImage
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.camera_alt,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isUploadingImage 
                                  ? 'Đang tải ảnh...' 
                                  : 'Thay đổi ảnh đại diện',
                              style: TextStyle(
                                color: _isUploadingImage ? Colors.grey : Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),                    const SizedBox(height: 32),

                    // Form fields
                    _buildTextField(
                      controller: _fullNameController,
                      label: 'Họ và tên',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập họ và tên';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _phoneController,
                      label: 'Số điện thoại',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 32),

                    // Save button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state is ProfileUpdateLoading ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is ProfileUpdateLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Lưu thay đổi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
