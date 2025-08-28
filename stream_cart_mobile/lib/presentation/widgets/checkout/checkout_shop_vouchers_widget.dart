import 'package:flutter/material.dart';
import '../../../domain/entities/cart/cart_entity.dart';
import '../../theme/app_colors.dart';
import '../../../domain/entities/shop_voucher/shop_voucher_entity.dart';
import '../../../domain/entities/shop_voucher/available_shop_voucher_entity.dart';
import 'available_shop_vouchers_sheet.dart';

class CheckoutShopVouchersWidget extends StatelessWidget {
  final List<CartShopEntity> shops;
  final Map<String, String> initialCodes;
  final void Function(String shopId, String code) onCodeChanged;
  final String? orderId;
  final void Function(String shopId, ApplyShopVoucherDataEntity data)? onApplied;

  const CheckoutShopVouchersWidget({
    super.key,
    required this.shops,
    required this.initialCodes,
    required this.onCodeChanged,
    this.orderId,
    this.onApplied,
  });

  @override
  Widget build(BuildContext context) {
    if (shops.isEmpty) return const SizedBox.shrink();
    return Column(
      children: shops.map((s) => _ShopVoucherRow(
        shop: s,
        initialCode: initialCodes[s.shopId] ?? '',
        onCodeChanged: onCodeChanged,
        orderId: orderId,
  onApplied: onApplied,
      )).toList(),
    );
  }
}

class _ShopVoucherRow extends StatefulWidget {
  final CartShopEntity shop;
  final String initialCode;
  final void Function(String shopId, String code) onCodeChanged;
  final String? orderId;
  final void Function(String shopId, ApplyShopVoucherDataEntity data)? onApplied;
  const _ShopVoucherRow({required this.shop, required this.initialCode, required this.onCodeChanged, this.orderId, this.onApplied});

  @override
  State<_ShopVoucherRow> createState() => _ShopVoucherRowState();
}

class _ShopVoucherRowState extends State<_ShopVoucherRow> {
  AvailableShopVoucherItemEntity? _selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.shop.shopName, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.brandDark)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                      builder: (_) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: AvailableShopVouchersSheet(
                          shopId: widget.shop.shopId,
                          orderAmount: widget.shop.totalPriceInShop,
                          onSelected: (item) {
                            setState(() {
                              _selected = item;
                            });
                            widget.onCodeChanged(widget.shop.shopId, item.voucher.code);
                            widget.onApplied?.call(
                              widget.shop.shopId,
                              ApplyShopVoucherDataEntity(
                                isApplied: true,
                                message: 'Đã chọn voucher',
                                discountAmount: item.discountAmount,
                                finalAmount: item.finalAmount,
                                voucherId: item.voucher.id,
                                voucherCode: item.voucher.code,
                                appliedAt: DateTime.now(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.brandPrimary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.card_giftcard, color: AppColors.brandPrimary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selected == null ? 'Chọn voucher phù hợp' : 'Voucher: ${_selected!.voucher.code}',
                            style: TextStyle(color: _selected == null ? Colors.grey[600] : AppColors.brandDark),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
              if (_selected != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Bỏ chọn',
                  icon: const Icon(Icons.clear, color: Colors.redAccent),
                  onPressed: () {
                    setState(() { _selected = null; });
                    widget.onCodeChanged(widget.shop.shopId, '');
                    widget.onApplied?.call(
                      widget.shop.shopId,
                      ApplyShopVoucherDataEntity(
                        isApplied: false,
                        message: 'Đã bỏ voucher',
                        discountAmount: 0,
                        finalAmount: widget.shop.totalPriceInShop,
                        voucherId: '',
                        voucherCode: '',
                        appliedAt: DateTime.now(),
                      ),
                    );
                  },
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
