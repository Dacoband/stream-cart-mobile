import 'package:flutter/material.dart';

class CheckoutPaymentMethodWidget extends StatelessWidget {
  final String selectedPaymentMethod;
  final void Function(String?) onPaymentMethodChanged;

  const CheckoutPaymentMethodWidget({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Phương thức thanh toán',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1),
          
          // Cash on Delivery
          _buildPaymentOption(
            'COD',
            'Thanh toán khi nhận hàng',
            'Thanh toán bằng tiền mặt khi nhận hàng',
            Icons.money,
            Colors.green,
          ),
          
          // Bank Transfer (enabled)
          _buildPaymentOption(
            'BANK_TRANSFER',
            'Chuyển khoản ngân hàng',
            'Chuyển khoản qua ngân hàng',
            Icons.account_balance,
            Colors.blue,
            isEnabled: true,
          ),
          
          // E-wallet (Coming soon)
          _buildPaymentOption(
            'E_WALLET',
            'Ví điện tử',
            'Thanh toán qua ví điện tử (Sắp có)',
            Icons.account_balance_wallet,
            Colors.orange,
            isEnabled: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor, {
    bool isEnabled = true,
  }) {
    final isSelected = selectedPaymentMethod == value;
    
    return InkWell(
      onTap: isEnabled ? () => onPaymentMethodChanged(value) : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.05) : null,
          border: isSelected 
              ? const Border(left: BorderSide(color: Color(0xFF4CAF50), width: 3))
              : null,
          ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: selectedPaymentMethod,
              onChanged: isEnabled ? (String? selectedValue) {
                if (selectedValue != null) {
                  onPaymentMethodChanged(selectedValue);
                }
              } : null,
              activeColor: const Color(0xFF4CAF50),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isEnabled ? iconColor : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isEnabled ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isEnabled ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            if (!isEnabled)
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}