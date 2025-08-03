import 'package:equatable/equatable.dart';

class ProductAttributeEntity extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? lastModifiedAt;
  final String? lastModifiedBy;

  const ProductAttributeEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.createdBy,
    this.lastModifiedAt,
    this.lastModifiedBy,
  });

  ProductAttributeEntity copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? createdBy,
    DateTime? lastModifiedAt,
    String? lastModifiedBy,
  }) {
    return ProductAttributeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        createdAt,
        createdBy,
        lastModifiedAt,
        lastModifiedBy,
      ];
}