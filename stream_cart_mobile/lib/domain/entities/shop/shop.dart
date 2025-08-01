import 'package:equatable/equatable.dart';

class Shop extends Equatable {
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

  const Shop({
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

  Shop copyWith({
    String? id,
    String? shopName,
    String? description,
    String? logoURL,
    String? coverImageURL,
    double? ratingAverage,
    int? totalReview,
    DateTime? registrationDate,
    String? approvalStatus,
    DateTime? approvalDate,
    String? bankAccountNumber,
    String? bankName,
    String? taxNumber,
    int? totalProduct,
    double? completeRate,
    bool? status,
    DateTime? createdAt,
    String? createdBy,
    DateTime? lastModifiedAt,
    String? lastModifiedBy,
    String? accountId,
  }) {
    return Shop(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      description: description ?? this.description,
      logoURL: logoURL ?? this.logoURL,
      coverImageURL: coverImageURL ?? this.coverImageURL,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      totalReview: totalReview ?? this.totalReview,
      registrationDate: registrationDate ?? this.registrationDate,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      approvalDate: approvalDate ?? this.approvalDate,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankName: bankName ?? this.bankName,
      taxNumber: taxNumber ?? this.taxNumber,
      totalProduct: totalProduct ?? this.totalProduct,
      completeRate: completeRate ?? this.completeRate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
      accountId: accountId ?? this.accountId,
    );
  }
}
