import 'package:flutter/material.dart';
import '../../../core/enums/address_type.dart';

class AddressTypeSelector extends StatelessWidget {
  final AddressType selectedType;
  final Function(AddressType) onTypeSelected;
  
  const AddressTypeSelector({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loại địa chỉ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF202328),
          ),
        ),
        
        const SizedBox(height: 12),
        
        Row(
          children: AddressType.values.map((type) {
            final isSelected = selectedType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTypeSelected(type),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? const Color(0xFF4CAF50).withOpacity(0.1)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFE0E0E0),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getTypeIcon(type),
                        size: 20,
                        color: isSelected 
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFF666666),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _getTypeText(type),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected 
                                ? FontWeight.w500 
                                : FontWeight.w400,
                            color: isSelected 
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFF666666),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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

  String _getTypeText(AddressType type) {
    switch (type) {
      case AddressType.shipping:
        return 'Địa chỉ giao hàng';
      case AddressType.business:
        return 'Địa chỉ văn phòng';
      case AddressType.residential:
        return 'Địa chỉ nhà riêng';
      case AddressType.both:
        return 'Địa chỉ chung';
      case AddressType.billing:
        return 'Địa chỉ thanh toán';
    }
  }
}