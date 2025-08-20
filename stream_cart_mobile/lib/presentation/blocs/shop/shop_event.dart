import 'package:equatable/equatable.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object?> get props => [];
}

class LoadShops extends ShopEvent {
  final int pageNumber;
  final int pageSize;
  final String? status;
  final String? approvalStatus;
  final String? searchTerm;
  final String? sortBy;
  final bool ascending;

  const LoadShops({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.status,
    this.approvalStatus,
    this.searchTerm,
    this.sortBy,
    this.ascending = true,
  });

  @override
  List<Object?> get props => [
        pageNumber,
        pageSize,
        status,
        approvalStatus,
        searchTerm,
        sortBy,
        ascending,
      ];
}

class LoadShopDetail extends ShopEvent {
  final String shopId;

  const LoadShopDetail(this.shopId);

  @override
  List<Object> get props => [shopId];
}

class LoadShopProducts extends ShopEvent {
  final String shopId;

  const LoadShopProducts(this.shopId);

  @override
  List<Object> get props => [shopId];
}

    class RefreshShopProducts extends ShopEvent {
      final String shopId;
      const RefreshShopProducts(this.shopId);

      @override
      List<Object> get props => [shopId];
    }

class SearchShops extends ShopEvent {
  final String searchTerm;
  final int pageNumber;
  final int pageSize;

  const SearchShops({
    required this.searchTerm,
    this.pageNumber = 1,
    this.pageSize = 10,
  });

  @override
  List<Object> get props => [searchTerm, pageNumber, pageSize];
}

class RefreshShops extends ShopEvent {
  const RefreshShops();
}
