enum UserRole {
  customer(1, 'Customer'), // Changed from 0 to 1
  seller(2, 'Seller');    // Changed from 1 to 2

  const UserRole(this.value, this.displayName);

  final int value;
  final String displayName;

  static UserRole fromValue(int value) {
    switch (value) {
      case 1:
        return UserRole.customer;
      case 2:
        return UserRole.seller;
      default:
        return UserRole.customer;
    }
  }

  static List<UserRole> get allRoles => UserRole.values;
}
