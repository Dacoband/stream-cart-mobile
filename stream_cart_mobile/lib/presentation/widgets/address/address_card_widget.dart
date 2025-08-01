import 'package:flutter/material.dart';
import '../../../domain/entities/address/address_entity.dart';
import '../../../core/enums/address_type.dart';

class AddressCard extends StatelessWidget {
  final AddressEntity address;
  final bool isSelected;
  final bool isDefault;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;
  
  const AddressCard({
    Key? key,
    required this.address,
    this.isSelected = false,
    this.isDefault = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSetDefault,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF4CAF50)
                : isDefault
                    ? const Color(0xFFB0F847)
                    : const Color(0xFFE0E0E0),
            width: isSelected || isDefault ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getTypeIcon(address.type),
                  size: 20,
                  color: const Color(0xFF4CAF50),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      if (isDefault) ...[
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFFFFA726),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          address.recipientName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF202328),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0F847),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Mặc định',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF202328),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                      case 'setDefault':
                        onSetDefault?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('Chỉnh sửa'),
                        ],
                      ),
                    ),
                    if (!isDefault)
                      const PopupMenuItem(
                        value: 'setDefault',
                        child: Row(
                          children: [
                            Icon(Icons.star_outline, size: 20),
                            SizedBox(width: 8),
                            Text('Đặt làm mặc định'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Xóa', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(
                    Icons.more_vert,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Address
            Text(
              '${address.street}, ${address.ward}, ${address.district}, ${address.city}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Phone
            Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  size: 16,
                  color: Color(0xFF666666),
                ),
                const SizedBox(width: 4),
                Text(
                  address.phoneNumber,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(AddressType type) {
    switch (type) {
      case AddressType.shipping:
        return Icons.home_outlined;
      case AddressType.business:
        return Icons.business_outlined;
      case AddressType.residential:
        return Icons.apartment_outlined;
      case AddressType.both:
        return Icons.location_city_outlined;
      case AddressType.billing:
        return Icons.account_balance_outlined;
    }
  }
}