import 'package:equatable/equatable.dart';

class AttributeValueEntity extends Equatable {
  final String id;
  final String attributeId;
  final String valueName;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? lastModifiedAt;
  final String? lastModifiedBy;

  const AttributeValueEntity({
    required this.id,
    required this.attributeId,
    required this.valueName,
    required this.createdAt,
    required this.createdBy,
    this.lastModifiedAt,
    this.lastModifiedBy,
  });

  AttributeValueEntity copyWith({
    String? id,
    String? attributeId,
    String? valueName,
    DateTime? createdAt,
    String? createdBy,
    DateTime? lastModifiedAt,
    String? lastModifiedBy,
  }) {
    return AttributeValueEntity(
      id: id ?? this.id,
      attributeId: attributeId ?? this.attributeId,
      valueName: valueName ?? this.valueName,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        attributeId,
        valueName,
        createdAt,
        createdBy,
        lastModifiedAt,
        lastModifiedBy,
      ];
}