import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/address_entity.dart';
import '../../blocs/address/address_bloc.dart';
import '../../blocs/address/address_event.dart';
import '../../blocs/address/address_state.dart';
import '../../widgets/address/address_form.dart';

class AddEditAddressPage extends StatefulWidget {
  final AddressEntity? initialAddress;
  
  const AddEditAddressPage({
    Key? key,
    this.initialAddress,
  }) : super(key: key);

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  bool get isEditing => widget.initialAddress != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          isEditing ? 'Chỉnh sửa địa chỉ' : 'Thêm địa chỉ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202328),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF202328),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          } else if (state is AddressCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Thêm địa chỉ thành công'),
                backgroundColor: Color(0xFF4CAF50),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else if (state is AddressUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật địa chỉ thành công'),
                backgroundColor: Color(0xFF4CAF50),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final isLoading = state is AddressLoading;

          return SingleChildScrollView(
            child: Column(
              children: [
                // White container for form
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page title and description
                      Text(
                        isEditing ? 'Cập nhật thông tin địa chỉ' : 'Thêm địa chỉ mới',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF202328),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEditing 
                            ? 'Chỉnh sửa thông tin địa chỉ giao hàng của bạn'
                            : 'Điền đầy đủ thông tin để thêm địa chỉ giao hàng mới',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Address Form
                      AddressForm(
                        initialAddress: widget.initialAddress,
                        isLoading: isLoading,
                        onSubmit: _handleFormSubmit,
                      ),
                    ],
                  ),
                ),

                // Important notes section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F8FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF2196F3).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: const Color(0xFF2196F3),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Lưu ý quan trọng',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Vui lòng cung cấp thông tin chính xác để đảm bảo giao hàng thành công\n'
                        '• Số điện thoại phải là số thật và có thể liên lạc được\n'
                        '• Địa chỉ mặc định sẽ được tự động chọn khi đặt hàng',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom spacing
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleFormSubmit(Map<String, dynamic> formData) {
    if (isEditing) {
      context.read<AddressBloc>().add(
        UpdateAddressEvent(
          id: widget.initialAddress!.id,
          recipientName: formData['recipientName'],
          street: formData['street'],
          ward: formData['ward'],
          district: formData['district'],
          city: formData['city'],
          country: formData['country'],
          postalCode: formData['postalCode'],
          phoneNumber: formData['phoneNumber'],
          type: formData['type'],
          latitude: formData['latitude'],
          longitude: formData['longitude'],
        ),
      );
    } else {
      context.read<AddressBloc>().add(
        CreateAddressEvent(
          recipientName: formData['recipientName'],
          street: formData['street'],
          ward: formData['ward'],
          district: formData['district'],
          city: formData['city'],
          country: formData['country'],
          postalCode: formData['postalCode'],
          phoneNumber: formData['phoneNumber'],
          isDefaultShipping: formData['isDefaultShipping'],
          latitude: formData['latitude'],
          longitude: formData['longitude'],
          type: formData['type'],
          shopId: null, 
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}