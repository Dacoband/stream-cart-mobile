import 'package:equatable/equatable.dart';
import '../../domain/entities/shop.dart';

class ShopResponse extends Equatable {
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPrevious;
  final bool hasNext;
  final List<Shop> items;

  const ShopResponse({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPrevious,
    required this.hasNext,
    required this.items,
  });

  factory ShopResponse.fromJson(Map<String, dynamic> json) {
    return ShopResponse(
      currentPage: json['currentPage'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasPrevious: json['hasPrevious'] ?? false,
      hasNext: json['hasNext'] ?? false,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ShopModel.fromJson(item).toEntity())
              .toList() ??
          [],
    );
  }

  @override
  List<Object> get props => [
        currentPage,
        pageSize,
        totalCount,
        totalPages,
        hasPrevious,
        hasNext,
        items,
      ];
}

class ShopModel extends Equatable {
  final String id;
  final String shopName;
  final String description;
  final String logoURL;
  final String coverImageURL;
  final double ratingAverage;
  final int totalReview;
  final DateTime registrationDate;
  final String approvalStatus;
  final DateTime? approvalDate;
  final String bankAccountNumber;
  final String bankName;
  final String taxNumber;
  final int totalProduct;
  final double completeRate;
  final bool status;
  final DateTime createdAt;
  final String createdBy;
  final DateTime lastModifiedAt;
  final String lastModifiedBy;
  final String accountId;

  const ShopModel({
    required this.id,
    required this.shopName,
    required this.description,
    required this.logoURL,
    required this.coverImageURL,
    required this.ratingAverage,
    required this.totalReview,
    required this.registrationDate,
    required this.approvalStatus,
    this.approvalDate,
    required this.bankAccountNumber,
    required this.bankName,
    required this.taxNumber,
    required this.totalProduct,
    required this.completeRate,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    required this.lastModifiedAt,
    required this.lastModifiedBy,
    required this.accountId,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'] ?? '',
      shopName: json['shopName'] ?? '',
      description: json['description'] ?? '',
      logoURL: json['logoURL'] ?? '',
      coverImageURL: json['coverImageURL'] ?? '',
      ratingAverage: (json['ratingAverage'] ?? 0).toDouble(),
      totalReview: json['totalReview'] ?? 0,
      registrationDate: DateTime.tryParse(json['registrationDate'] ?? '') ?? DateTime.now(),
      approvalStatus: json['approvalStatus'] ?? '',
      approvalDate: json['approvalDate'] != null 
          ? DateTime.tryParse(json['approvalDate'])
          : null,
      bankAccountNumber: json['bankAccountNumber'] ?? '',
      bankName: json['bankName'] ?? '',
      taxNumber: json['taxNumber'] ?? '',
      totalProduct: json['totalProduct'] ?? 0,
      completeRate: (json['completeRate'] ?? 0).toDouble(),
      status: json['status'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      createdBy: json['createdBy'] ?? '',
      lastModifiedAt: DateTime.tryParse(json['lastModifiedAt'] ?? '') ?? DateTime.now(),
      lastModifiedBy: json['lastModifiedBy'] ?? '',
      accountId: json['accountId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopName': shopName,
      'description': description,
      'logoURL': logoURL,
      'coverImageURL': coverImageURL,
      'ratingAverage': ratingAverage,
      'totalReview': totalReview,
      'registrationDate': registrationDate.toIso8601String(),
      'approvalStatus': approvalStatus,
      'approvalDate': approvalDate?.toIso8601String(),
      'bankAccountNumber': bankAccountNumber,
      'bankName': bankName,
      'taxNumber': taxNumber,
      'totalProduct': totalProduct,
      'completeRate': completeRate,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastModifiedAt': lastModifiedAt.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
      'accountId': accountId,
    };
  }

  Shop toEntity() {
    return Shop(
      id: id,
      shopName: shopName,
      description: description,
      logoURL: logoURL,
      coverImageURL: coverImageURL,
      ratingAverage: ratingAverage,
      totalReview: totalReview,
      registrationDate: registrationDate,
      approvalStatus: approvalStatus,
      approvalDate: approvalDate,
      bankAccountNumber: bankAccountNumber,
      bankName: bankName,
      taxNumber: taxNumber,
      totalProduct: totalProduct,
      completeRate: completeRate,
      status: status,
      createdAt: createdAt,
      createdBy: createdBy,
      lastModifiedAt: lastModifiedAt,
      lastModifiedBy: lastModifiedBy,
      accountId: accountId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        shopName,
        description,
        logoURL,
        coverImageURL,
        ratingAverage,
        totalReview,
        registrationDate,
        approvalStatus,
        approvalDate,
        bankAccountNumber,
        bankName,
        taxNumber,
        totalProduct,
        completeRate,
        status,
        createdAt,
        createdBy,
        lastModifiedAt,
        lastModifiedBy,
        accountId,
      ];
}
