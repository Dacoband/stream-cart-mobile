enum AddressType {
  residential(0, 'Nhà riêng'),
  business(1, 'Cơ sở kinh doanh'),
  shipping(2, 'Địa chỉ giao hàng'),
  billing(3, 'Địa chỉ thanh toán'),
  both(4, 'Vừa giao hàng vừa thanh toán');

  const AddressType(this.value, this.displayName);

  final int value;
  final String displayName;

  static AddressType fromValue(int value) {
    switch (value) {
      case 0:
        return AddressType.residential;
      case 1:
        return AddressType.business;
      case 2:
        return AddressType.shipping;
      case 3:
        return AddressType.billing;
      case 4:
        return AddressType.both;
      default:
        return AddressType.residential;
    }
  }

  static AddressType? fromName(String name) {
    switch (name.toLowerCase()) {
      case 'residential':
        return AddressType.residential;
      case 'business':
        return AddressType.business;
      case 'shipping':
        return AddressType.shipping;
      case 'billing':
        return AddressType.billing;
      case 'both':
        return AddressType.both;
      default:
        return null;
    }
  }

  String toJson() => name;

  @override
  String toString() => displayName;
}