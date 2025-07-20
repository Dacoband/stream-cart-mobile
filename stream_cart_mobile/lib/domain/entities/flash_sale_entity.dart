class FlashSaleEntity {
  final String id;
  final String productId;
  final String? variantId;
  final double flashSalePrice;
  final int quantityAvailable;
  final int quantitySold;
  final bool isActive;
  final DateTime startTime;
  final DateTime endTime;

  const FlashSaleEntity({
    required this.id,
    required this.productId,
    this.variantId,
    required this.flashSalePrice,
    required this.quantityAvailable,
    required this.quantitySold,
    required this.isActive,
    required this.startTime,
    required this.endTime,
  });

  // Calculate discount percentage
  double getDiscountPercentage(double originalPrice) {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - flashSalePrice) / originalPrice * 100);
  }

  // Check if flash sale is currently active
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && now.isAfter(startTime) && now.isBefore(endTime);
  }

  // Get remaining time
  Duration get timeRemaining {
    final now = DateTime.now();
    if (now.isAfter(endTime)) return Duration.zero;
    return endTime.difference(now);
  }

  // Get sold percentage
  double get soldPercentage {
    final total = quantityAvailable + quantitySold;
    if (total <= 0) return 0;
    return (quantitySold / total * 100);
  }
}
